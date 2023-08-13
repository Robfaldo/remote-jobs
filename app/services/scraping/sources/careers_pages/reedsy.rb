module Scraping
  module Sources
    module CareersPages
      class Reedsy < Workable
        def job_preview_scraping_options
          {
            wait_time: nil,
            wait_browser: "load",
            javascript_scenario: javascript_scenario,
            allow_css_and_images: true
          }
        end

        def job_elements(all_jobs_page)
          all_jobs_page.search('[data-ui="job"]')
        end

        def title_from_job_element(job_element)
          job_element.at('[data-ui="job-title"]').text
        end

        private

        def javascript_scenario
          click_department_filter = %{
           document.querySelector('[aria-owns="departments-filter_listbox"]').click()
          }

          select_engineering_option = %{
            const engineeringElement = document.getElementById('departments-filter_listbox');
            const engineeringOption = Array.from(engineeringElement.querySelectorAll('span')).find(span => span.textContent.trim() === "Engineering");
            engineeringOption.click();
          }

          click_show_more = %{
            loadMoreButton = document.querySelector('[data-ui="load-more-button"]');
            if (loadMoreButton) {
              loadMoreButton.click()
            };
          }

          {
            instructions: [
              { wait: 500 },
              { evaluate: click_department_filter },
              { wait: 2000 },
              { evaluate: select_engineering_option },
              { wait: 2000 },
              { evaluate: click_show_more },
              { wait: 2000 }
            ]
          }
        end
      end
    end
  end
end

