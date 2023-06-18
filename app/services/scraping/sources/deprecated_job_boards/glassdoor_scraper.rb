module Scraping
  module DeprecatedJobBoards
    class GlassdoorScraper < ::Scraping::Sources::Base
      private

      def source
        :glassdoor
      end

      def scrape_all_jobs_page_options(link)
        {
          link: link,
          wait_time: 20000,
          premium_proxy: true
        }
      end

      def scrape_job_page_options(job)
        {
          link: job.url,
          javascript_snippet: javascript,
          wait_time: 10000,
          premium_proxy: true
        }
      end

      def job_element
        '.react-job-listing'
      end

      def job_element_title(job)
        job.search('.jobLink').search('span').last.text
      end

      def job_element_link(job)
        'https://www.glassdoor.co.uk' + job.search('.jobLink').first.get_attribute('href')
      end

      def job_element_company(job)
        job.search('.jobLink').search('span')[1].text
      end

      def job_element_location(job)
        job.search('.e1rrn5ka0').text
      end

      def create_job(job, scraped_job_page)
        description = scraped_job_page.search('.desc')[-1].text
        new_link = scraped_job_page.search('#current-url').first.text # the link changes after this page loads

        if field_empty?(job.company)
          rating = scraped_job_page.search('.e11nt52q1').first.search('span').first&.text
          company = scraped_job_page.search('.e11nt52q1').first.text.strip
          company.gsub(rating, '') if rating # doesn't always have a rating
        else
          company = job.company
        end

        new_job = Job.new(
          title: job.title,
          url: new_link,
          location: job.location,
          description: description,
          source: source,
          status: "scraped",
          company: CompanyServices::FindOrCreateCompany.call(company),
          scraped_company: company,
          source_id: job.url
        )

        save_job(new_job, scraped_job_page)
      end

      def javascript
        %{
          (function () {
              setTimeout(function () {
                  if (document.getElementsByClassName('ecgq1xb2').length > 0) {
                    document.getElementsByClassName('ecgq1xb2')[0].click(); // click the show more button
                  };
                  el = document.createElement('div');
                  el.id = 'current-url';
                  el.textContent = window.location.href;
                  document.body.appendChild(el);
              }, 5000);
          })();
        }
      end
    end
  end
end
