module Scraping
  module Sources
    module CareersPages
      class Zeroheight < Workable
        def job_elements(all_jobs_page)
          all_jobs_page.search('[data-ui="job"]')
        end

        def title_from_job_element(job_element)
          job_element.at('[data-ui="job-title"]').text
        end
      end
    end
  end
end

