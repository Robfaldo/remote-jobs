require 'simple-rss'
require 'open-uri'

module Scraping
  class TechnojobsScraper < DefaultScraper
    def get_jobs
      search_links.each do |location, data|
        links_to_scrape = Scraping::GetLinksForLocation.call(data)

        links_to_scrape.each do |link|
          jobs_from_rss = SimpleRSS.parse open(link.gsub(' ', '%20'))

          jobs_to_filter = extract_jobs_to_filter(jobs_from_rss.items, location)
          filtered_jobs = JobFiltering::FilterJobs.new(jobs_to_filter).call
          jobs_to_scrape = filtered_jobs.select{ |j| j.status == "approved" }

          extract_and_save_job(jobs_to_scrape)
        end
      end
    end

    private

    def source
      :technojobs
    end

    def scrape_job_page_options(job)
      {
        link: job.job_link
      }
    end

    def job_element_title(job)
      job[:title]
    end

    def job_element_link(job)
      job[:link]
    end

    def create_job(job, scraped_job_page)
      job_summary_rows = scraped_job_page.search('.job-listing-table').first.search('tbody').search('tr')
      company = job_summary_rows.to_a.filter{|row| row.text.include?('Recruiter:')}.first.text.gsub('Recruiter:', '').strip
      location = job_summary_rows.to_a.filter{|row| row.text.include?('Location:')}.first.text.gsub('Location:', '').strip
      description = scraped_job_page.search('.job-listing-body').first.text

      new_job = Job.new(
          title: job.title,
          job_link: job.job_link,
          location: location,
          description: description,
          source: source,
          status: "scraped",
          company: CompanyServices::FindOrCreateCompany.call(company),
          scraped_company: company,
          job_board: "technojobs",
          source_id: job.job_link,
          searched_location: job.searched_location
      )

      save_job(new_job, scraped_job_page)
    end
  end
end
