module Scraping
  module Sources
    module CareersPages
      class Judge < Base
        def job_elements(all_jobs_page)
          all_jobs_page.search('a[href*="/jobs/"]')
        end

        def title_from_job_element(job_element)
          job_element.at('.job-title').text
        end

        def url_from_job_element(job_element)
          uri = URI(company.careers_page_url)
          url_without_path = "#{uri.scheme}://#{uri.host}"
          "#{url_without_path}#{job_element.get_attribute("href")}"
        end

        def location_from_job_element(job_element)
          job_element.at('.location-info').children.first.text.strip
        end
      end
    end
  end
end

