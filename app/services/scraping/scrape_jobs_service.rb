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
        puts "RollBarErrorHere:"
        puts e.class
        puts e

        Rollbar.error(e)
      end
    end
  end
end
