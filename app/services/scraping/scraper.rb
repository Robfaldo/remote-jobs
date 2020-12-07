require "scraper_api"

module Scraping
  class Scraper
    def scrape(link)
      result = client.get(link, country_code: "US").raw_body

      Nokogiri::HTML.parse(result)
    end

    def client
      @client ||= ScraperAPI::Client.new("0c6a2674d4eb45d9e53a9a206ab3606a")
    end
  end
end
