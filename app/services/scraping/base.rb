module Scraping
  class Base
    def get_jobs
      search_links_for_all_locations.each do |location, data|
        links_for_location = Scraping::GetLinksForLocation.call(data)

        links_for_location.each do |link|
          options = scrape_all_jobs_page_options(link)
          job_page = ScrapePage.call(**options)
          job_previews = extract_job_previews_from_page(job_page, location)
          job_previews_to_scrape = decide_job_previews_to_scrape(job_previews)
          scrape_jobs(job_previews_to_scrape)
        rescue => e
          SendToErrorMonitors.send_error(error: e, additional: {link: link, location: location})
        end
      end
    end

    private

    def extract_job_previews_from_page(all_jobs_page, searched_location)
      job_elements = all_jobs_page.search(job_element)

      job_elements.each_with_object([]) do |job_element, jobs|
        job_preview = create_job_preview(job_element, searched_location)
        jobs << job_preview
      rescue => e
        SendToErrorMonitors.send_error(error: e, additional: { job: job_element })
      end
    end

    def decide_job_previews_to_scrape(job_previews)
      filtered_jobs = JobPreviewEvaluation::Pipeline.new(job_previews).process
      filtered_jobs.select{ |job_preview| job_preview.status == "evaluated" }
    end

    def scrape_jobs(job_previews)
      job_previews.each do |job_preview|
        options = scrape_job_page_options(job_preview)
        job_page = ScrapePage.call(**options)

        create_job(job_preview, job_page)
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

    def save_job(job, scraped_page = nil)
      job.save!
    rescue => e
      rollbar_error = SendToErrorMonitors.send_error(error: e, additional: { job: job.attributes })

      if scraped_page
        job_for_email = job.attributes
        job_for_email["description"] = "removed"

        ScraperMailer.job_save_error_html(
          html: scraped_page.to_html,
          job: job_for_email,
          error: e,
          rollbar_uuid: rollbar_error[:uuid]
        ).deliver_now
      end
    end

    def job_element_company(_job)
      nil # optional to scrape so children can overwrite if used
    end

    def job_element_location(_job)
      nil # optional to scrape so children can overwrite if used
    end

    def search_links_for_all_locations
      class_name_underscored = self.class.name.split("::").last.underscore
      search_links_file_path = Rails.root.join("config", "search_links", "#{class_name_underscored}.yml")
      YAML.load(File.read(search_links_file_path))
    end

    def field_empty?(field)
      field == "" || field == " " || field == nil
    end
  end
end
