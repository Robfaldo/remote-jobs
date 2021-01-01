module Scraping
  class TotaljobsScraper < Scraper
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          scraped_page = scrape_page(link: link, wait_time: 5000)

          scraped_jobs = scraped_page.search('.job')

          jobs_to_evaluate = extract_jobs_to_evaluate(scraped_jobs)

          jobs_to_scrape = evaluate_jobs(jobs_to_evaluate)

          extract_and_save_job(jobs_to_scrape)
        end
      end
    end

    private

    def evaluate_jobs(jobs_to_evaluate)
      jobs_to_scrape = []

      jobs_to_evaluate.each do |job|
        if JobFiltering::TitleRequirements.new.meets_title_requirements?(job)
          jobs_to_scrape.push(job)
        end
      end

      jobs_to_scrape
    end

    def extract_jobs_to_evaluate(scraped_all_jobs_page)
      jobs_to_evaluate = []

      scraped_all_jobs_page.each do |job|
        link = job.search('.job-title').search('a').first.get_attribute('href')
        company = job.search('h3').search('a').text
        title = job.search('h2').text.strip
        location = job.search('.location').search('span').first.text.strip

        jobs_to_evaluate.push(JobToEvaluate.new(title: title, link: link, company: company, location: location))
      end

      jobs_to_evaluate
    end

    def extract_and_save_job(evaluated_jobs)
      evaluated_jobs.each do |job|
        next if Job.where(job_link: job.link).count > 0

        begin
          scraped_job_page = scrape_page(link: job.link, premium_proxy: true)

          create_job(job, scraped_job_page)
        rescue => e
          Rollbar.error(e, job.instance_values.to_s)
        end
      end
    end

    def create_job(job, scraped_job_page)
      description = scraped_job_page.search('.job-description').text

      new_job = Job.new(
          title: job.title,
          job_link: job.link,
          location: job.location,
          description: description,
          source: :totaljobs,
          status: "scraped",
          company: job.company,
          job_board: "Totaljobs",
          source_id: job.link
      )

      new_job.save!
    end
  end
end
