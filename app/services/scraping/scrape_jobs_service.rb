module Scraping
  class ScrapeJobsService
    class ScrapingError < StandardError; end

    SCRAPERS = [
      Scraping::CvLibraryScraper,
      Scraping::GlassdoorScraper,
      Scraping::IndeedScraper,
      Scraping::StackoverflowScraper,
      Scraping::CompaniesDirectScraper,
      Scraping::TotaljobsScraper,
      Scraping::TechnojobsScraper,
      Scraping::GoogleScraper
    ]

    def call
      SCRAPERS.each do |scraper|
        scraper.new.get_jobs

      rescue Net::ReadTimeout
        retry
      rescue => e
        puts "RollBarErrorHere:"
        puts e.class
        puts e

        Rollbar.error(e)
      end
    end
  end
end
