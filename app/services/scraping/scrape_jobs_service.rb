module Scraping
  class ScrapeJobsService
    SCRAPERS = [
      Scraping::GoogleScraper
      # Scraping::IndeedScraper,
      # Scraping::StackoverflowScraper
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
