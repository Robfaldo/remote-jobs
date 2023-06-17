module Scraping
  class Scraper
    def scrape_page(link:, javascript_snippet: nil, wait_time: 5000, custom_google: false, premium_proxy: false)
      response = Scrapers::ScrapingBee.new.scrape_page(
        link: link,
        javascript_snippet: javascript_snippet,
        wait_time: wait_time,
        custom_google: custom_google,
        premium_proxy: premium_proxy
      )

      begin
        Nokogiri::HTML.parse(response.body)
      rescue Exception
        # https://stackoverflow.com/a/4789702/5615805
        raise $!, "Error parsing response. Response: #{response}. Link: #{link}", $!.backtrace
      end
    end
  end
end
