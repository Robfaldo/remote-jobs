module Scraping
  module Sources
    module CareersPages
      class Koinly < Base
        def job_elements(all_jobs_page)
          all_jobs_page.search('li:has(a > span[title])')
        end

        def title_from_job_element(job_element)
          job_element.at('a > span[title]').text
        end

        def url_from_job_element(job_element)
          job_element.at('a').get_attribute("href")
        end

        def location_from_job_element(job_element)
          job_element.search('a > div').search('span')[2].text
        end

        def sanitized_location(_job_element)
          "location_unknown"
        end
      end
    end
  end
end

