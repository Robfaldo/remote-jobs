module Scraping
  class ScrapeCareersPage
    def initialize(company:)
      @scraper = Scraping::Scrapers::ScrapingBee.new
      @company = company
      @scraper_class = "Scraping::Sources::CareersPages::#{company.scraper_class}".constantize.new(company)
    end

    def call
      all_jobs_page = scraper.scrape_page(link: company.careers_page_url)
      job_previews = extract_job_previews(all_jobs_page)

      JobServices::UpdateJobsNoLongerLiveOnCareersSite.new.call(
        job_previews_currently_on_careers_site: job_previews,
        company: company
      )

      job_previews_to_scrape = decide_job_previews_to_scrape(job_previews)
      scrape_jobs(job_previews_to_scrape)
    rescue => e
      SendToErrorMonitors.send_error(error: e, additional: {link: company.careers_page_url})
    end

    private

    attr_reader :scraper, :company, :scraper_class

    def extract_job_previews(all_jobs_page)
      scraper_class.job_elements(all_jobs_page).each_with_object([]) do |job_element, jobs|
        job_preview = JobPreview.create!(
          title: scraper_class.title_from_job_element(job_element),
          url: scraper_class.url_from_job_element(job_element),
          source: :direct_from_careers_page,
          company: company.name,
          status: "scraped",
          location: scraper_class.location_from_job_element(job_element)
        )
        sanitized_location = scraper_class.respond_to?(:sanitized_location) && scraper_class.sanitized_location(job_element)
        job_preview.update!(sanitized_location: sanitized_location) if sanitized_location

        jobs << job_preview
      rescue => e
        rollbar_error = SendToErrorMonitors.send_error(error: e, additional: { job: job_element })
        ScraperMailer.job_save_error_html(
          html: all_jobs_page.to_html,
          error: e,
          rollbar_uuid: rollbar_error[:uuid]
        ).deliver_now
      end
    end

    def decide_job_previews_to_scrape(job_previews)
      filtered_jobs = JobPreviewEvaluation::Pipeline.new(job_previews).process
      filtered_jobs.select{ |job_preview| job_preview.status == "evaluated" }
    end

    def scrape_jobs(job_previews)
      job_previews.each do |job_preview|
        job_page = scraper.scrape_page(link: job_preview.url)
        structured_job = JSON.parse(job_page.xpath('//script[@type="application/ld+json"]').first)
        location = JobServices::ParseStructuredJob.new(structured_job, job_preview).location

        Job.create!(
          job_preview: job_preview,
          title: structured_job["title"],
          url: job_preview.url,
          location: location,
          description: structured_job["description"],
          source: :direct_from_careers_page,
          company: company,
          scraped_company: company.name,
          source_id: job_preview.url,
          job_posting_schema: structured_job,
          status: "scraped",
          live_on_careers_site: true
        )
      rescue => e
        rollbar_error = SendToErrorMonitors.send_error(error: e, additional: { job: job_preview.instance_values.to_s })

        if job_page
          job_for_email = job_preview.attributes
          job_for_email["description"] = "removed"

          ScraperMailer.job_save_error_html(
            html: job_page.to_html,
            job: job_for_email,
            error: e,
            rollbar_uuid: rollbar_error[:uuid]
          ).deliver_now
        end
      end
    end
  end
end
