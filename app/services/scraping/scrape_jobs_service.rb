module Scraping
  class ScrapeJobsService
    class ScrapingError < StandardError; end
    MAX_NET_TIMEOUT_RETRIES = 3

    SCRAPERS = [
      Scraping::CvLibraryScraper,
      Scraping::GlassdoorScraper,
      Scraping::IndeedScraper,
      Scraping::StackoverflowScraper,
      Scraping::TotaljobsScraper,
      Scraping::TechnojobsScraper,
      Scraping::GoogleScraper
      # Scraping::CompaniesDirectScraper
    ]

    def call
      time_started = Time.now

      results = Parallel.map(SCRAPERS, in_threads: SCRAPERS.count) do |scraper|
        retries ||= 0

        scraper.new.get_jobs

        { scraper => Time.now - time_started }
      rescue Net::ReadTimeout
        sleep 5
        retry if (retries += 1) < MAX_NET_TIMEOUT_RETRIES
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
