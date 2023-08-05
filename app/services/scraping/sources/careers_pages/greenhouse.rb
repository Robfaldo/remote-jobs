module Scraping
  module Sources
    module CareersPages
      class Greenhouse
        def self.job_elements(all_jobs_page)
          all_jobs_page.search('.opening')
        end

        def self.title_from_job_element(job_element)
          job_element.at('a').text
        end

        def self.url_from_job_element(job_element)
          job_element.at('a').get_attribute("href")
        end

        def self.location_from_job_element(job_element)
          job_element.at('.location').text.strip
        end
      end
    end
  end
end

