require "scraper_api"

module Scraping
  class Scraper
    include ScrapingHelper

    def scrape_page(link:, javascript_snippet: nil, wait_time: 5000, custom_google: false, premium_proxy: false, use_zenscrape: false)
      if use_zenscrape
        response = Zenscrape.new.scrape_page(
          link: link,
          wait_time: wait_time,
          premium_proxy: premium_proxy
        )
      else
        response = ScrapingBee.new.scrape_page(
          link: link,
          javascript_snippet: javascript_snippet,
          wait_time: wait_time,
          custom_google: custom_google,
          premium_proxy: premium_proxy
        )
      end

      Nokogiri::HTML.parse(response.body)
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

    def evaluate_jobs(jobs_to_evaluate)
      jobs_to_scrape = []

      jobs_to_evaluate.each do |job|
        if job.meets_minimum_requirements?
          jobs_to_scrape.push(job)
        end
      end

      jobs_to_scrape
    end
  end
end
