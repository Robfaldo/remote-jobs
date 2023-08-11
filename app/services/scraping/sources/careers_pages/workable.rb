module Scraping
  module Sources
    module CareersPages
      class Workable < Base
        def job_preview_scraping_options
          {
            # if i don't include wait_time as a query for scrapingbee then
            # the page shows a "no internet connection" and none of the content
            # is added. Even with this option, if you include wait_time then
            # it won't work (which is why wait_time is nil above)
            wait_time: nil,
            wait_browser: "load"
          }
        end

        def job_scraping_options
          {
            # See note on the one for job_preview
            wait_time: nil,
            wait_browser: "load"
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

