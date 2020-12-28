module Scraping
  class ScrapeJobsService
    class ScrapingError < StandardError; end

    SCRAPERS = [
      # Scraping::CvLibraryScraper,
      # Scraping::GlassdoorScraper,
      Scraping::GoogleScraper
      # Scraping::IndeedScraper,
      # Scraping::StackoverflowScraper,
      # Scraping::CompaniesDirectScraper,
      # Scraping::TotaljobsScraper
    ]

    def call
      SCRAPERS.each do |scraper|
        scraper.new.get_jobs

      rescue => e
        puts "SentryErrorHere:"
        puts e.class
        puts e
        Sentry.capture_exception(e)
      end
    end
  end
end
