module Scraping
  class ScrapeJobsService
    class ScrapingError < StandardError; end

    SCRAPERS = [
      Scraping::CwjobsScraper,
      Scraping::ReedScraper,
      Scraping::JobserveScraper,
      Scraping::CvLibraryScraper,
      Scraping::GlassdoorScraper,
      Scraping::IndeedScraper,
      Scraping::StackoverflowScraper,
      Scraping::TotaljobsScraper,
      Scraping::TechnojobsScraper,
      Scraping::GoogleScraper
    ]

    ## Decomissioned
    # Scraping::CompaniesDirectScraper
    ################

    def call
      time_started = Time.now

      results = Parallel.map(SCRAPERS, in_threads: SCRAPERS.count) do |scraper|
        scraper_start_time = Time.now

        scraper.new.get_jobs

        minutes_to_scrape = (Time.now - scraper_start_time) / 60

        { scraper: scraper, scraper_start_time: scraper_start_time, minutes_to_scrape: minutes_to_scrape }
      rescue => e
        puts "RollBarErrorHere:"
        puts e.class
        puts e

        Rollbar.error(e)
      end

      Rollbar.info("Scraping Completed", :time_started => time_started, results: results)
    end
  end
end
