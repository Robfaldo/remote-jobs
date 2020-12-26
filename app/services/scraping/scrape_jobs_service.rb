module Scraping
  class ScrapeJobsService
    SCRAPERS = [
      Scraping::GlassdoorScraper,
      Scraping::GoogleScraper,
      Scraping::IndeedScraper,
      Scraping::StackoverflowScraper
    ]

    def call
      SCRAPERS.each do |scraper|
        scraper.new.get_jobs
      end
    end
  end
end
