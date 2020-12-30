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

      Nokogiri::HTML.parse(response.body)
    rescue => e
      Rollbar.error(e)
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

    def evaluate_jobs(jobs_to_evaluate)
      jobs_to_scrape = []

      jobs_to_evaluate.each do |job|
        if JobFiltering::TitleRequirements.new.meets_title_requirements?(job)
          jobs_to_scrape.push(job)
        end
      end

      jobs_to_scrape
    end
  end
end
