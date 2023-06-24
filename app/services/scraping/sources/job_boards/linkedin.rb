module Scraping
  module Sources
    module JobBoards
      class Linkedin < ::Scraping::Sources::Base
        private

        def scrape_all_jobs_page_options(link)
          {
            link: link,
            wait_time: 5000
          }
        end

        def scrape_job_page_options(job)
          {
            link: job.url,
            wait_time: 6000,
            javascript_snippet: javascript
          }
        end

        def job_elements(all_jobs_page)
          all_jobs_page.search('.base-card')
        end

        def create_job_preview(job_element, searched_location)
          title = job_element.at('.base-search-card__title') || job_element.at('.m_base-search-card__title')
          company = job_element.at('.base-search-card__subtitle') || job_element.at('.m_base-search-card__subtitle')
          location = job_element.at('.job-search-card__location') || job_element.at('.m_job-search-card__location')

          JobPreview.create!(
            title: title.text.strip,
            url: job_element_link(job_element),
            source: :linkedin,
            searched_location: searched_location,
            company: company.text.strip,
            location: location.text.strip,
            status: "scraped"
          )
        end

        def create_job(job_preview, scraped_job_page)
          description = scraped_job_page.search('.show-more-less-html__markup').text

          if field_empty?(job_preview.company)
            company = scraped_job_page.search('.topcard__content-left').search('h3').search('span').first.text.strip
          else
            company = job_preview.company
          end

          job = Job.new(
            title: job_preview.title,
            url: job_preview.url,
            location: job_preview.location,
            description: description,
            source: :linkedin,
            status: "scraped",
            company: CompanyServices::FindOrCreateCompany.call(company),
            scraped_company: company,
            source_id: job_preview.url
          )

          save_job(job, scraped_job_page)
        end

        def job_element_link(job)
          link = job.at('.base-card__full-link') || job.at('.m_base-card__full-link')
          link.get_attribute('href')
        rescue
          job.search('.base-search-card__title').first.ancestors('a').first.get_attribute('href')
        end

        def javascript
          %{
            (function () {
                setTimeout(function () {
                    document.querySelector('.show-more-less-html__button').click()
                }, 3000);
            })();
          }
        end
      end
    end
  end
end
