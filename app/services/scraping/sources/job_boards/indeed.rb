module Scraping
  module Sources
    module JobBoards
      class Indeed < ::Scraping::Sources::Base
        private

        def scrape_all_jobs_page_options(link)
          {
            link: link,
          }
        end

        def scrape_job_page_options(job)
          {
            link: job.url,
          }
        end

        def job_elements(all_jobs_page)
          all_jobs_page.search('.cardOutline')
        end

        def create_job_preview(job_element, searched_location)
          JobPreview.create!(
            title: job_element.at('[@title]').text,
            url: job_element_link(job_element),
            source: :indeed,
            searched_location: searched_location,
            company: job_element.at('.companyName').text.strip,
            location: job_element.at('.companyLocation').text.strip,
            status: "scraped"
          )
        end

        def job_element_link(job)
          id = job.search('a').first.search('span').first.get_attribute('id').gsub('jobTitle-', '')
          'https://uk.indeed.com/viewjob?jk=' + id
        end

        def create_job(job_preview, scraped_job_page)
          structured_job = JSON.parse(scraped_job_page.xpath('//script[@type="application/ld+json"]').first)

          job = Job.new(
            title: structured_job["title"],
            url: job_preview.url,
            location: job_preview.location,
            description: structured_job["description"],
            source: :indeed,
            status: "scraped",
            company: CompanyServices::FindOrCreateCompany.call(job_preview.company),
            scraped_company: job_preview.company,
            source_id: job_preview.url,
            job_posting_schema: structured_job
          )

          save_job(job, scraped_job_page)
        end
      end
    end
  end
end
