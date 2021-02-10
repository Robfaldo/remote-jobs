module Scraping
  class ScrapeJobsService
    class ScrapingError < StandardError; end

    SCRAPERS_CONCURRENT = [
      Scraping::CwjobsScraper,
      Scraping::ReedScraper,
      Scraping::JobserveScraper,
      Scraping::CvLibraryScraper,
      Scraping::IndeedScraper,
      Scraping::StackoverflowScraper,
      Scraping::TotaljobsScraper,
      Scraping::TechnojobsScraper,
    ]

    # ones that use ScrapingBee that can't be run concurrently
    SCRAPERS_CONSECUTIVE = [
      Scraping::LinkedinScraper,
      Scraping::GlassdoorScraper,
      Scraping::GoogleScraper
    ]

    def call
      Rollbar.info("Scraping Started")

      time_started = Time.now

      results = Parallel.map(SCRAPERS_CONCURRENT, in_threads: SCRAPERS_CONCURRENT.count) do |scraper|
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

      SCRAPERS_CONSECUTIVE.each do |scraper|
        scraper_start_time = Time.now

        scraper.new.get_jobs

        minutes_to_scrape = (Time.now - scraper_start_time) / 60

        results.push({ scraper: scraper, scraper_start_time: scraper_start_time, minutes_to_scrape: minutes_to_scrape })
      end

      total_time_to_scrape = Time.now - time_started

      Rollbar.info("Scraping Completed", time_started: time_started, total_time_to_scrape: total_time_to_scrape, results: results)
    end
  end
end
