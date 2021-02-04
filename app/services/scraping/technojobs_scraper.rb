require 'simple-rss'
require 'open-uri'

module Scraping
  class TechnojobsScraper < DefaultScraper

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          jobs_from_rss = SimpleRSS.parse open(link.gsub(' ', '%20'))

          jobs_to_filter = extract_jobs_to_filter(jobs_from_rss.items)
          filtered_jobs = JobFiltering::FilterJobs.new(jobs_to_filter).call

          extract_and_save_job(filtered_jobs)
        end
      end
    end

    private

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
          source: :technojobs,
          status: "scraped",
          company: company,
          job_board: "technojobs",
          source_id: job.job_link
      )

      new_job.save!
    end
  end
end
