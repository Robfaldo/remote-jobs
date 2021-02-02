module Scraping
  class DefaultScraper
    include ScrapingHelper

    LOCATIONS = ["London"]
    MAX_PAGINATION_PAGES_TO_SCRAPE = 1

    def initialize(scraper: Scraper.new)
      @scraper = scraper
    end

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          begin
            options = scrape_all_jobs_page_options(link)

            scraped_all_jobs_page = scraper.scrape_page(options)

            scrape_and_save_jobs(scraped_all_jobs_page)

            if handle_pagination
              remaining_pages = pages_remaining_to_scrape(scraped_all_jobs_page)

              scrape_additional_pages(remaining_pages, link)
            end
          rescue => e
            Rollbar.error(e, link: link, location: location)
          end
        end
      end
    end

    private

    attr_reader :scraper

    def scrape_and_save_jobs(scraped_all_jobs_page)
      scraped_jobs = scraped_all_jobs_page.search(job_element)

      jobs_to_scrape = evaluated_jobs(scraped_jobs)

      extract_and_save_job(jobs_to_scrape)
    end

    def evaluated_jobs(scraped_jobs)
      jobs_to_evaluate = extract_jobs_to_evaluate(scraped_jobs)

      evaluate_jobs(jobs_to_evaluate)
    end

    def extract_and_save_job(jobs)
      jobs.each do |job|
        next if already_added_filter.recently_added?(job) || wrong_job_type_filter.wrong_job_title?(job)

        begin
          options = scrape_job_page_options(job)

          scraped_job_page = scraper.scrape_page(options)

          create_job(job, scraped_job_page)
        rescue => e
          Rollbar.error(e, job: job.instance_values.to_s)
        end
      end
    end

    def scrape_additional_pages(pages_remaining_to_scrape, link)
      pages_remaining_to_scrape.times do |page|
        current_paginated_page = page + 1 # + 1 because page starts at 0. The first pagination page (i.e. the 2nd total page) will have current_paginated_page == 1

        paginated_page_link = paginated_page_link(link, current_paginated_page)

        break if current_paginated_page > MAX_PAGINATION_PAGES_TO_SCRAPE

        options = scrape_all_jobs_page_options(paginated_page_link)

        scraped_all_jobs_page = scraper.scrape_page(options)

        scrape_and_save_jobs(scraped_all_jobs_page)
      end
    end

    def extract_jobs_to_evaluate(scraped_jobs)
      jobs_to_evaluate = []

      scraped_jobs.each do |job|
        begin
          title = job_element_title(job)
          link = job_element_link(job)
          company = job_element_company(job)
          location = job_element_location(job)

          scraped_job = ScrapedJob.new(
            title: title,
            link: link
          )
          scraped_job.company = company if company
          scraped_job.location = location if location

          scraped_job.save!

          jobs_to_evaluate.push(new_job)
        rescue => e
          Rollbar.error(e, job: job)
        end
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

    #### Defaults ####

    def job_element_company(job)
      nil # optional to scrape so children can overwrite if used
    end

    def job_element_location(job)
      nil # optional to scrape so children can overwrite if used
    end

    def handle_pagination
      false
    end

    def search_links
      YAML.load(File.read(yaml_path))
    end

    def yaml_path
      Rails.root.join("config", "search_links", "#{class_name_underscored}.yml")
    end

    def class_name_underscored
      self.class.name.split("::")[1].underscore
    end

    def already_added_filter
      JobFiltering::AlreadyAddedRecently.new
    end

    def wrong_job_type_filter
      JobFiltering::WrongJobType.new
    end
    #####################
  end
end
