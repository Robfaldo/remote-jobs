module Scraping
  module Sources
    module CareersPages
      class Tails < Base
        def job_elements(all_jobs_page)
          all_jobs_page.search('li > a[href*="https://careers.tails.com/jobs/"]')
        end

        def title_from_job_element(job_element)
          job_element.at('span[title]').text
        end

        def url_from_job_element(job_element)
          job_element.get_attribute('href')
        end

        def location_from_job_element(job_element)
          job_element.at('div').text.strip
        end

        def sanitized_location(_job_element)
          "location_unknown"
        end
      end
    end
  end
end

