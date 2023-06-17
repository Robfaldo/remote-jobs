module Scraping
  class ScrapeJobsService
    class ScrapingError < StandardError; end
    SCRAPERS_CONSECUTIVE = [
      Scraping::LinkedinScraper,
      # Scraping::GoogleScraper
      # Scraping::GlassdoorScraper,
      # Scraping::ReedScraper,
      # Scraping::JobserveScraper,
      # Scraping::CvLibraryScraper,
      # Scraping::IndeedScraper,
      # Scraping::StackoverflowScraper,
      # Scraping::TechnojobsScraper
    ]

    def call
      SendToErrorMonitors.send_notification(message: "Scraping Started")
      time_started = Time.now

      scraping_results = SCRAPERS_CONSECUTIVE.each_with_object([]) do |scraper, results|
        scraper.new.get_jobs

        minutes_to_scrape = (Time.now - time_started) / 60

        results.push({ scraper: scraper, scraper_start_time: time_started, minutes_to_scrape: minutes_to_scrape })
      rescue => e
        puts "RollBarErrorHere:"
        puts e.class
        puts e

        SendToErrorMonitors.send_error(error: e)
      end

      total_time_to_scrape = Time.now - time_started

      SendToErrorMonitors.send_notification(message: "Scraping Completed", additional: { time_started: time_started, total_time_to_scrape: total_time_to_scrape, results: scraping_results })
    end
  end
end
