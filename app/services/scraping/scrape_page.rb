module Scraping
  class ScrapePage
    def self.call(link:,
                  javascript_snippet: nil,
                  wait_time: 5000,
                  custom_google: false,
                  premium_proxy: true,
                  allow_css_and_images: false)
      response = Scrapers::ScrapingBee.new.scrape_page(
        link: link,
        javascript_snippet: javascript_snippet,
        wait_time: wait_time,
        custom_google: custom_google,
        premium_proxy: premium_proxy,
        allow_css_and_images: allow_css_and_images
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
