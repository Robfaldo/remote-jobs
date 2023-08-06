module Scraping
  module Sources
    module CareersPages
      class MindfulChef < Base
        def job_elements(all_jobs_page)
          all_jobs_page.search('.job-box-link').uniq {|element| element.get_attribute('href') }
        end

        def title_from_job_element(job_element)
          job_element.at('.jb-title').text.strip
        end

        def url_from_job_element(job_element)
          job_element.get_attribute("href")
        end

        def location_from_job_element(job_element)
          job_element.at('.multi-offices-desktop').text.strip
        end

        def sanitized_location(job_element)
          job_element.at('.multi-offices-desktop')
                     .text
                     .strip
                     .gsub(/\s*·\s*/, '')
                     .strip
                     .gsub("Mindful Chef ", "")
                     .gsub(" HQ", "")
                     .gsub("Oaklands international (Redditch)", "Redditch")
        end
      end
    end
  end
end

