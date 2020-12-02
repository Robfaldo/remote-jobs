require_relative './indeed_scraper'

module Scraping
  class ScrapeJobsService
    SCRAPERS = [
      Scraping::IndeedScraper
    ]

    def call
      jobs = []

      SCRAPERS.each do |scraper|
        new_jobs = scraper.new.get_jobs

        jobs.concat(new_jobs)
      end

      jobs
    end
  end
end
