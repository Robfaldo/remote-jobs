module Scraping
  module Sources
    module CareersPages
      class Accredible < Base
        def job_preview_scraping_options
          {
            wait_time: 20000,
            allow_css_and_images: true
          }
        end

        def job_elements(all_jobs_page)
          all_jobs_page.search('.rt-tbody > .rt-tr-group')
        end

        def title_from_job_element(job_element)
          job_element.at('a').text
        end

        def url_from_job_element(job_element)
          uri = URI(company.careers_page_url)
          url_without_path = "#{uri.scheme}://#{uri.host}"
          "#{url_without_path}#{job_element.at('a').get_attribute("href")}"
        end

        def location_from_job_element(job_element)
          job_element.search('.external-content-wrap > div')[1].text
        end
      end
    end
  end
end

