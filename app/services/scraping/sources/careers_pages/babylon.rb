module Scraping
  module Sources
    module CareersPages
      class Babylon < Base
        def job_elements(all_jobs_page)
          all_jobs_page.search('.GreenHouseJobBoard_jobOpeningOverviewContainer__v00i9')
        end

        def title_from_job_element(job_element)
          job_element.at('[data-kontent-element-codename="title"]').text
        end

        def url_from_job_element(job_element)
          job_element.at('a').get_attribute("href")
        end

        def location_from_job_element(job_element)
          job_element.at('[data-kontent-element-codename="title"] + p').text
        end

        def sanitized_location(job_element)
          job_element.at('[data-kontent-element-codename="title"] + p')
                     .text
                     .gsub("Technology, Engineering, ", "")
        end
      end
    end
  end
end

