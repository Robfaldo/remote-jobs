require "scraper_api"

module Scraping
  class Scraper
    def scrape_page(link:, javascript_snippet: nil, wait_time: 5000, custom_google: false, premium_proxy: false)
      response = client.scrape_page(
        link: link,
        javascript_snippet: javascript_snippet,
        wait_time: wait_time,
        custom_google: custom_google,
        premium_proxy: premium_proxy
      )

      if response
        scraped_page = Nokogiri::HTML.parse(response.body)
      else
        puts "There was no response from scraping bee for link: #{link}"
      end
    end

    private

    def client
      ScrapingBee.new
    end
  end
end
