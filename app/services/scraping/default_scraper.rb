module Scraping
  class DefaultScraper
    include ScrapingHelper

    MAX_PAGINATION_PAGES_TO_SCRAPE = 1

    def initialize(scraper: Scraper.new)
      @scraper = scraper
    end

    def get_jobs
      search_links.each do |location, data|
        links_to_scrape = Scraping::GetLinksForLocation.call(data)

        links_to_scrape.each do |link|
          options = scrape_all_jobs_page_options(link)
          scraped_all_jobs_page = scraper.scrape_page(options)

          process_all_jobs_page(scraped_all_jobs_page, location)

          if handle_pagination
            remaining_pages = pages_remaining_to_scrape(scraped_all_jobs_page)
            scrape_additional_pages(remaining_pages, link, location)
          end
        rescue => e
          SendToErrorMonitors.send_error(error: e, additional: {link: link, location: location})
        end
      end
    end

    private

    attr_reader :scraper

    def process_all_jobs_page(scraped_all_jobs_page, searched_location)
      job_elements = scraped_all_jobs_page.search(job_element)
      jobs_to_filter = extract_jobs_to_filter(job_elements, searched_location)
      filtered_jobs = JobFiltering::FilterJobs.new(jobs_to_filter).call

      jobs_to_scrape = filtered_jobs.select{ |j| j.status == "approved" }

      extract_and_save_job(jobs_to_scrape)
    end

    def extract_jobs_to_filter(job_elements, searched_location)
      jobs = []

      job_elements.each do |job|
        begin
          title = job_element_title(job)
          link = job_element_link(job)
          company = job_element_company(job)
          scraped_location = job_element_location(job)

          scraped_job = ScrapedJob.new(
            title: title,
            job_link: link,
            source: source,
            searched_location: searched_location
          )
          scraped_job.company = company if company
          scraped_job.location = scraped_location if scraped_location

          save_job(scraped_job)

          jobs.push(scraped_job)
        rescue => e
          SendToErrorMonitors.send_error(error: e, additional: { job: job })
        end
      end

      jobs
    end

    def extract_and_save_job(jobs)
      jobs.each do |job|
        begin
          options = scrape_job_page_options(job)
          scraped_job_page = scraper.scrape_page(options)

          create_job(job, scraped_job_page)
        rescue => e
          rollbar_error = SendToErrorMonitors.send_error(error: e, additional: { job: job.instance_values.to_s })

          if scraped_job_page
            job_for_email = job.attributes
            job_for_email["description"] = "removed"

            ScraperMailer.job_save_error_html(
              html: scraped_job_page.to_html,
              job: job_for_email,
              error: e,
              rollbar_uuid: rollbar_error[:uuid]
            ).deliver_now
          end
        end
      end
    end

    def scrape_additional_pages(pages_remaining_to_scrape, link, searched_location)
      pages_remaining_to_scrape.times do |page|
        current_paginated_page = page + 1 # + 1 because page starts at 0. The first pagination page (i.e. the 2nd total page) will have current_paginated_page == 1
        paginated_page_link = paginated_page_link(link, current_paginated_page)

        break if current_paginated_page > MAX_PAGINATION_PAGES_TO_SCRAPE

        options = scrape_all_jobs_page_options(paginated_page_link)
        scraped_all_jobs_page = scraper.scrape_page(options)

        process_all_jobs_page(scraped_all_jobs_page, searched_location)
      end
    end

    # def save_job(job, scraped_page = nil)
    #   job_save_retries = 0
    #
    #   begin
    #     job.save!
    #   rescue ActiveRecord::ConnectionTimeoutError => e
    #     sleep rand(5)
    #     job_save_retries += 1
    #     retry if job_save_retries < 3
    #     raise e
    #   rescue => e
    #     rollbar_error = SendToErrorMonitors.send_error(error e, additional: { job: job.attributes })
    #
    #     if scraped_page
    #       job_for_email = job.attributes
    #       job_for_email["description"] = "removed"
    #
    #       ScraperMailer.job_save_error_html(
    #         html: scraped_page.to_html,
    #         job: job_for_email,
    #         error: e,
    #         rollbar_uuid: rollbar_error[:uuid]
    #       ).deliver_now
    #     end
    #   end
    # end

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

    def field_empty?(field)
      field == "" || field == " " || field == nil
    end
    #####################
  end
end
