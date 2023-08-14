module Scraping
  module Sources
    module CareersPages
      class Alliants < Base
        def job_preview_scraping_options
          {
            wait_time: nil,
            wait_browser: "load",
            allow_css_and_images: true
          }
        end

        def job_elements(all_jobs_page)
          all_jobs_page.search('a[href*="https://careers.alliants.com/jobs/"]')
        end

        def title_from_job_element(job_element)
          job_element.at('span[title]').text
        end

        def location_from_job_element(job_element)
          job_element.search('div').search('span')[2].text
        end

        def url_from_job_element(job_element)
          job_element.get_attribute("href")
        end

        def sanitized_location(_job_element)
          # The location is too difficult to scrape because it
          # doesn't follow a predictable pattern and there's no classes
          # to target it
          # There's very few jobs and currently all UK based so i'll
          # go location_unknown and let it scrape and get location from
          # posting
          "location_unknown"
        end
      end
    end
  end
end

