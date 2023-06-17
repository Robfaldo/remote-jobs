module Scraping
  class Scraper
    class NotFoundResponse < StandardError; end
    class ApiErrorToRetry < StandardError; end
    include ScrapingHelper

    def scrape_page(link:, javascript_snippet: nil, wait_time: 5000, custom_google: false, premium_proxy: false)
      response = Scrapers::ScrapingBee.new.scrape_page(
        link: link,
        javascript_snippet: javascript_snippet,
        wait_time: wait_time,
        custom_google: custom_google,
        premium_proxy: premium_proxy
      )

      # if javascript_snippet || custom_google
      #   response = ScrapingBee.new.scrape_page(
      #     link: link,
      #     javascript_snippet: javascript_snippet,
      #     wait_time: wait_time,
      #     custom_google: custom_google,
      #     premium_proxy: premium_proxy
      #   )
      # end

      begin
        Nokogiri::HTML.parse(response.body)
      rescue Exception
        # https://stackoverflow.com/a/4789702/5615805
        raise $!, "Error parsing response. Response: #{response}. Link: #{link}", $!.backtrace
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
