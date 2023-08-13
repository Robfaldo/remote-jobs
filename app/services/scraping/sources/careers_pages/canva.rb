module Scraping
  module Sources
    module CareersPages
      class Canva < Base
        def job_elements(all_jobs_page)
          all_jobs_page.search('.card-job')
        end

        def title_from_job_element(job_element)
          job_element.at('.card-title').text
        end

        def url_from_job_element(job_element)
          uri = URI(company.careers_page_url)
          url_without_path = "#{uri.scheme}://#{uri.host}"
          "#{url_without_path}#{job_element.at('a').get_attribute("href")}"
        end

        def location_from_job_element(job_element)
          job_element.search('ul > li')[1].text
        end
      end
    end
  end
end

