require "scraper_api"

module Scraping
  class Scraper
    def initialize(client: ScrapingBee.new(api_key: ENV["SCRAPING_BEE_KEY"]))
      @client = client
    end

    def scrape_page(link:, javascript_snippet: nil, wait_time: 5000, custom_google: false, premium_proxy: false)
      raise "Missing ScrapingBee API key" unless ENV["SCRAPING_BEE_KEY"]

      response = client.scrape_page(
        link: link,
        javascript_snippet: javascript_snippet,
        wait_time: wait_time,
        custom_google: custom_google,
        premium_proxy: premium_proxy
      )

      scraped_page = Nokogiri::HTML.parse(response.body)
    end

    private

    attr_reader :client
  end
end
