module Scraping
  class ScrapeJobsService
    SCRAPERS = [
      Scraping::GoogleScraper,
      Scraping::IndeedScraper,
      Scraping::StackoverflowScraper
    ]

    def call
      raise 'im an error'
      SCRAPERS.each do |scraper|
        scraper.new.get_jobs
      end
    end
  end
end
