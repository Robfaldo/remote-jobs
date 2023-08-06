module Scraping
  module Sources
    module CareersPages
      class Greenhouse < Base
        def job_elements(all_jobs_page)
          all_jobs_page.search('.opening')
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
          job_element.at('.location').text.strip
        end
      end
    end
  end
end

