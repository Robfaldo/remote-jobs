module Scraping
  class ScrapeJobsService
    SCRAPERS = [
      Scraping::GoogleScraper,
      Scraping::IndeedScraper,
      Scraping::StackoverflowScraper
    ]

    def call
      result_summary = []

      SCRAPERS.each do |scraper|
        result = scraper.new.get_jobs

        result_summary.push(result)
      end

      result_summary
    end
  end
end
