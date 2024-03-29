module Scraping
  module Sources
    module DeprecatedJobBoards
      class TotaljobsScraper < ::Scraping::Sources::Base
        private

        def source
          :totaljobs
        end

        def scrape_all_jobs_page_options(link)
          {
            link: link,
            wait_time: 5000,
            premium_proxy: true
          }
        end

        def scrape_job_page_options(job)
          {
            link: job.url,
            premium_proxy: true
          }
        end

        def job_element
          '.job'
        end

        def job_element_company(job)
          job.search('h3').search('a').text
        end

        def job_element_title(job)
          job.search('h2').text.strip
        end

        def job_element_location(job)
          job.search('.location').search('span').first.text.strip
        end

        def job_element_link(job)
          job.search('.job-title').search('a').first.get_attribute('href')
        end

        def handle_pagination
          false
        end

        def pages_remaining_to_scrape(scraped_all_jobs_page)
          jobs_appearing_in_search = scraped_all_jobs_page.search('.page-title').search('span').first.text.to_i
          jobs_per_page = 20
          total_pages_to_scrape = (jobs_appearing_in_search / jobs_per_page.to_f).ceil
          total_pages_to_scrape - 1 # we already scraped the 1st page
        end

        def paginated_page_link(link, current_paginated_page)
          link + "&page=#{current_paginated_page + 1}"
        end

        def create_job(job, scraped_job_page)
          description = scraped_job_page.search('.job-description').text

          new_job = Job.new(
              title: job.title,
              url: job.url,
              location: job.location,
              description: description,
              source: source,
              status: "scraped",
              company: CompanyServices::FindOrCreateCompany.call(job.company),
              scraped_company: job.company,
              source_id: job.url
          )

          save_job(new_job, scraped_job_page)
        end
      end
    end
  end
end
