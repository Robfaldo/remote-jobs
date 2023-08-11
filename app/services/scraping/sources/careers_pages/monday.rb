module Scraping
  module Sources
    module CareersPages
      class Monday < Base
        def job_preview_scraping_options
          {
            # i think i always need wait_time:nil & wait_browser:"load" if including js scenario
            wait_time: nil,
            wait_browser: "load",
            javascript_scenario: javascript_scenario
          }
        end

        def job_elements(all_jobs_page)
          all_jobs_page.search('tr:has(td > a > article.media > figure + div.media-content)')
        end

        def title_from_job_element(job_element)
          job_element.at('.position-name').text
        end

        def url_from_job_element(job_element)
          uri = URI(company.careers_page_url)
          url_without_path = "#{uri.scheme}://#{uri.host}"
          "#{url_without_path}#{job_element.at('a').get_attribute("href")}"
        end

        def location_from_job_element(job_element)
          job_element.search('td').last.text
        end

        private

        def javascript_scenario
          select_london_js = %{
            function getElementsByText(targetText, tagName = 'strong') {
              return Array.from(document.querySelectorAll(tagName)).filter(el => {
                return el.textContent.trim().includes(targetText);
              });
            };
            getElementsByText("London, UK")[0].click();
          }

          select_r_and_d_js = %{
            function getElementsByText(targetText, tagName = 'strong') {
              return Array.from(document.querySelectorAll(tagName)).filter(el => {
                return el.textContent.trim().includes(targetText);
              });
            };
            getElementsByText("The builders of the most innovative, lovable products", "p")[0].click()
          }

          click_show_more_jobs = %{
            function getElementsByText(targetText, tagName = 'strong') {
              return Array.from(document.querySelectorAll(tagName)).filter(el => {
                return el.textContent.trim().includes(targetText);
              });
            };
            const showMoreOpenings = getElementsByText("Show more openings", "a");
            if(showMoreOpenings.length > 0) {
              showMoreOpenings[0].click()
            };
          }

          {
            instructions: [
              { wait: 1000 },
              { evaluate: select_london_js },
              { wait: 2000 },
              { evaluate: select_r_and_d_js },
              { wait: 2000 },
              { evaluate: click_show_more_jobs },
              { wait: 1000 }
            ]
          }
        end
      end
    end
  end
end
