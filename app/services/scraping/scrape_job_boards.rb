module Scraping
  class ScrapeJobBoards
    class ScrapingError < StandardError; end
    JOB_BOARDS = [
      Scraping::Sources::JobBoards::Linkedin,
      Scraping::Sources::JobBoards::Indeed
    ]

    def call
      SendToErrorMonitors.send_notification(message: "Scraping Started")
      time_started = Time.now

      scraping_results = JOB_BOARDS.each_with_object([]) do |job_board, results|
        job_board.new.get_jobs

        minutes_to_scrape = (Time.now - time_started) / 60

        results.push({ job_board: job_board, scraper_start_time: time_started, minutes_to_scrape: minutes_to_scrape })
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
