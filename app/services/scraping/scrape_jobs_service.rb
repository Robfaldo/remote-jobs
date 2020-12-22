module Scraping
  class ScrapeJobsService
    SCRAPERS = [
      Scraping::GoogleScraper,
      Scraping::IndeedScraper,
      Scraping::StackoverflowScraper
    ]

    def call
      Sentry.capture_exception('this is a string')
      SCRAPERS.each do |scraper|
        scraper.new.get_jobs
      end
    end
  end
end
