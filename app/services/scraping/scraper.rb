require "scraper_api"

module Scraping
  class Scraper
    def scrape(link)
      result = client.get(link)

      Nokogiri::HTML.parse(result.raw_body)
    end

    def client
      @client ||= ScraperAPI::Client.new("0c6a2674d4eb45d9e53a9a206ab3606a")
    end
  end
end
