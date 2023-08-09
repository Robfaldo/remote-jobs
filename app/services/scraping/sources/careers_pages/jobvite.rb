module Scraping
  module Sources
    module CareersPages
      class Jobvite < Base
        def job_elements(all_jobs_page)
          all_jobs_page.search('.jv-job-list tr')
        end

        def title_from_job_element(job_element)
          job_element.search('.jv-job-list-name').text.strip
        end

        def url_from_job_element(job_element)
          uri = URI(company.careers_page_url)
          url_without_path = "#{uri.scheme}://#{uri.host}"
          "#{url_without_path}#{job_element.at('a').get_attribute("href")}"
        end

        def sanitized_location(job_element)
          location = job_element.at('.jv-job-list-location').text.strip

          # Annoyingly they have locations on the job preview like this where the location
          # is hidden. We'll just scrape it and then work out location from the actual Job.

          # <tr>
          #   <td class="jv-job-list-name">
          #     <a href="/funding-circle-uk/job/oz8fnfw3">Principal Engineer (US)</a>
          #   </td>
          #   <td class="jv-job-list-location">
          #     <div class="jv-meta">
          #       2 Locations
          #     </div>
          #   </td>
          # </tr>
          location_contains_number_then_location = !!location.match(/\b\d+ locations\b/)

          if location_contains_number_then_location
            "location_unknown"
          else
            location
          end
        end

        def location_from_job_element(job_element)
          job_element.at('.jv-job-list-location').text.strip
        end
      end
    end
  end
end

