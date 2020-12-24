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

    def search_links
      YAML.load(File.read(yaml_path))
    end

    def yaml_path
      Rails.root.join("config", "search_links", "#{class_name_underscored}.yml")
    end

    def class_name_underscored
      self.class.name.split("::")[1].underscore
    end

    private

    def client
      ScrapingBee.new
    end
  end
end
