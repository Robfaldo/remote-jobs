module Scraping
  module Sources
    module CareersPages
      class Lever < Base
        def job_elements(all_jobs_page)
          all_jobs_page.search('.posting')
        end

        def title_from_job_element(job_element)
          job_element.at('[data-qa="posting-name"]').text
        end

        def url_from_job_element(job_element)
          job_element.at('a').get_attribute("href")
        end

        def location_from_job_element(job_element)
          job_element.at('.location').text.strip
        end
      end
    end
  end
end

