module Scraping
  module Sources
    module CareersWebsite
      class Fresha < ::Scraping::Sources::FromSingleLink
        private

        def scrape_all_jobs_page_options
          {
            link: 'https://apply.workable.com/fresha/',
            stealth_proxy: true
          }
        end

        def scrape_job_page_options(job)
          {
            link: job.url,
            stealth_proxy: true
          }
        end

        def job_elements(all_jobs_page)
          elements = all_jobs_page.search('[data-ui="job"]')
          SendToErrorMonitors.send_notification(message: "Fresha careers page has no job elements") if elements.empty?
          elements
        end

        def create_job_preview(job_element, _searched_location)
          JobPreview.create!(
            title: job_element.at('[data-ui="job-title"]').text.strip,
            url: "https://apply.workable.com#{job_element.at('a')['href']}",
            source: :fresha_careers_website,
            company: "fresha",
            location: job_element.at('[data-ui="job-location"]').text.strip,
            status: "scraped"
          )
        end

        def create_job(job_preview, scraped_job_page)
          description = scraped_job_page.at('[data-ui="job-description"]').text

          job = Job.new(
            title: job_preview.title,
            url: job_preview.url,
            location: job_preview.location,
            description: description,
            source: :fresha_careers_website,
            status: "scraped",
            company: CompanyServices::FindOrCreateCompany.call(job_preview.company),
            scraped_company: job_preview.company,
            source_id: job_preview.url
          )

          save_job(job, scraped_job_page)
        end
      end
    end
  end
end
