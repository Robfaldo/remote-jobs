module Scraping
  class ScrapeJobsService
    SCRAPERS = [
      Scraping::CvLibraryScraper,
      Scraping::GlassdoorScraper,
      Scraping::GoogleScraper,
      Scraping::IndeedScraper,
      Scraping::StackoverflowScraper,
      Scraping::CompaniesDirectScraper
    ]

    def call
      SCRAPERS.each do |scraper|
        scraper.new.get_jobs
      end
    end
  end
end
