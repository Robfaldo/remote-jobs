require 'simple-rss'
require 'open-uri'

module Scraping
  class TechnojobsScraper < DefaultScraper

    private

    def scrape_job_page_options(job)
      {
        link: job.link
      }
    end

    def initial_method
      :rss
    end

    def rss_link_top_open(link)
      link.gsub(' ', '%20')
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
          job_link: job.link,
          location: location,
          description: description,
          source: :technojobs,
          status: "scraped",
          company: company,
          job_board: "technojobs",
          source_id: job.link
      )

      new_job.save!
    end
  end
end
