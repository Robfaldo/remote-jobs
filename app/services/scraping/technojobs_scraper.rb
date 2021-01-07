require 'simple-rss'
require 'open-uri'

module Scraping
  class TechnojobsScraper < Scraper
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          jobs_from_rss = SimpleRSS.parse open(link.gsub(' ', '%20'))

          extract_and_save_job(jobs_from_rss, location)
        end
      end
    end

    private

    def extract_and_save_job(jobs_from_rss, location)
      jobs_from_rss.items.each do |job|
        unless Job.where(source_id: job[:link]).count > 0
          passes_title_requirements = JobFiltering::TitleRequirements.new.job_to_eval_meets_minimum_requirements(job)
          final_location = location
          description = job[:description]
          company = "Unknown"

          if passes_title_requirements
            scraped_job_page = scrape_page(link: job[:link])
            job_summary_rows = scraped_job_page.search('.job-listing-table').first.search('tbody').search('tr')
            company = job_summary_rows.to_a.filter{|row| row.text.include?('Recruiter:')}.first.text.gsub('Recruiter:', '').strip
            final_location = job_summary_rows.to_a.filter{|row| row.text.include?('Location:')}.first.text.gsub('Location:', '').strip
            description = scraped_job_page.search('.job-listing-body').first.text
          end

          new_job = Job.new(
              title: job[:title],
              job_link: job[:link],
              location: final_location,
              description: description,
              source: :technojobs,
              status: "scraped",
              company: company,
              job_board: "technojobs",
              source_id: job[:link]
          )

          new_job.save!
        end
      end
    end
  end
end
