module Scraping
  class DefaultScraper
    LOCATIONS = ["London"]

    def initialize(scraper: Scraper.new)
      @scraper = scraper
    end

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          scraped_all_jobs_page = scraper.scrape_page(link: link, wait_time: 10000)

          scraped_jobs = scraped_all_jobs_page.search(job_element)

          jobs_to_evaluate = extract_jobs_to_evaluate(scraped_jobs)

          jobs_to_scrape = evaluate_jobs(jobs_to_evaluate)

          extract_and_save_job(jobs_to_scrape)
        end
      end
    end

    private

    attr_reader :scraper

    def extract_jobs_to_evaluate(scraped_all_jobs_page)
      jobs_to_evaluate = []

      scraped_all_jobs_page.each do |job|
        title = job_element_title(job)
        link = job_element_link(job)

        jobs_to_evaluate.push(
          JobToEvaluate.new(title: title, link: link)
        )
      end

      jobs_to_evaluate
    end

    def evaluate_jobs(jobs_to_evaluate)
      jobs_to_scrape = []

      jobs_to_evaluate.each do |job|
        if job.meets_minimum_requirements?
          jobs_to_scrape.push(job)
        end
      end

      jobs_to_scrape
    end

    def extract_and_save_job(jobs)
      jobs.each do |job|
        next if Job.where(source_id: job.link).count > 0

        begin
          scraped_job_page = scraper.scrape_page(link: job.link)

          create_job(job, scraped_job_page)
        rescue => e
          Rollbar.error(e, job: job.instance_values.to_s)
        end
      end
    end

    ########## non job/scraping related ##########

    def search_links
      YAML.load(File.read(yaml_path))
    end

    def yaml_path
      Rails.root.join("config", "search_links", "#{class_name_underscored}.yml")
    end

    def class_name_underscored
      self.class.name.split("::")[1].underscore
    end
  end
end