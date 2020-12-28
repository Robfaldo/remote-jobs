require 'simple-rss'
require 'open-uri'

module Scraping
  class CompaniesDirectScraper < Scraper
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          scraped_page = scrape_page(link: link, wait_time: 5000)

          scraped_jobs = scraped_page.search('.job_listing')

          extract_and_save_job(scraped_jobs, location)
        end
      end
    end

    private

    def extract_and_save_job(scraped_jobs, location)
      scraped_jobs.each do |job|
        link = job.search('a').first.get_attribute('href')
        company = job.search('strong').text
        title = job.search('.position').search('h3').text
        description = job.search('.tagline').text

        next if Job.where(job_link: link).count > 0

        new_job = Job.new(
            title: title,
            job_link: link,
            location: location,
            description: description,
            source: :companies_direct,
            status: "scraped",
            company: company,
            job_board: "Companies Direct"
        )

        new_job.save!
      end
    end
  end
end