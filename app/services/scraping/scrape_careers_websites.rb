module Scraping
  class ScrapeCareersWebsites
    class ScrapingError < StandardError; end

    def call
      SendToErrorMonitors.send_notification(message: "Careers website scraping started")
      time_started = Time.now

      careers_websites = [Scraping::Sources::CareersWebsite::Fresha]
      scraping_results = careers_websites.each_with_object([]) do |website, results|
        website.new.get_jobs

        minutes_to_scrape = (Time.now - time_started) / 60

        results.push({ careers_website: website, scraper_start_time: time_started, minutes_to_scrape: minutes_to_scrape })
      rescue => e
        puts "RollBarErrorHere:"
        puts e.class
        puts e

        SendToErrorMonitors.send_error(error: e)
      end

      total_time_to_scrape = Time.now - time_started

      SendToErrorMonitors.send_notification(message: "Careers website scraping completed", additional: { time_started: time_started, total_time_to_scrape: total_time_to_scrape, results: scraping_results })
    end
  end
end
