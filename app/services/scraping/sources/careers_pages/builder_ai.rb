module Scraping
  module Sources
    module CareersPages
      class BuilderAi < Base
        def job_elements(all_jobs_page)
          all_jobs_page.search('.whr-item')
        end

        def title_from_job_element(job_element)
          job_element.at('.whr-title').text
        end

        def url_from_job_element(job_element)
          job_element.at('a').get_attribute("href")
        end

        def location_from_job_element(job_element)
          job_element.at('.whr-location').text.strip
        end

        def sanitized_location(job_element)
          job_element.at('.whr-location').text.strip.gsub("Location: ", "")
        end
      end
    end
  end
end

