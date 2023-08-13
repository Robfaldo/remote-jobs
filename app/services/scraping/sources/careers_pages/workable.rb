module Scraping
  module Sources
    module CareersPages
      class Workable < Base
        def job_preview_scraping_options
          {
            wait_time: nil,
            wait_browser: "load",
            allow_css_and_images: true
          }
        end

        def job_scraping_options
          {
            # See note on the one for job_preview
            wait_time: nil,
            wait_browser: "load",
            allow_css_and_images: true
          }
        end

        def job_elements(all_jobs_page)
          all_jobs_page.search('[data-ui="job-opening"]')
        end

        def title_from_job_element(job_element)
          job_element.at('[data-id="job-item"]').text
        end

        def url_from_job_element(job_element)
          uri = URI(company.careers_page_url)
          url_without_path = "#{uri.scheme}://#{uri.host}"
          "#{url_without_path}#{job_element.at('a').get_attribute("href")}"
        end

        def location_from_job_element(job_element)
          job_element.at('[data-ui="job-location"]').text
        end
      end
    end
  end
end

