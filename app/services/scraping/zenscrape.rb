module Scraping
  class Zenscrape
    class ZenscrapeError < StandardError; end
    class NotFoundResponse < StandardError; end
    class ApiErrorToRetry < StandardError; end
    include ScrapingHelper

    NUM_OF_INITIAL_ATTEMPTS = 10
    PREMIUM_ATTEMPTS = 5
    USER_AGENTS = YAML.load(File.read('config/user_agents.yml'))

    def initialize(api_key: ENV["ZENSCRAPE_API_KEY"])
      raise ZenscrapeError.new("Missing ZenscrapeError API key") unless ENV["ZENSCRAPE_API_KEY"]

      @api_key = api_key
    end

    def scrape_page(link:, wait_time:, premium_proxy:)
      # Removing this temporarily as it's breaking glassdoor and we might not need it.
      headers = {
        apikey: @api_key # this can go in query params if we want to add custom headers (adding custom headers and keeping API key here will send the API key to the job site)
        # "User-Agent" => USER_AGENTS.sample # see note on keep_headers below for why I'm removing it
      }

      query = {
        url: link,
        wait_for: (wait_time/1000).to_s, # send in seconds, not milliseconds
        block_resources: 'stylesheet,image,media', # I could add more here
        render: "true", # this costs 5 credits and could sometimes be skipped (future optimisation)
        # keep_headers: "true", # adding this is making glassdoor return an empty page and I'm not sure why. Maybe if we overwrite headers we need to provide all headers?
      }

      query[:premium_proxy] = "true" if premium_proxy
      query[:location] = "gb" if premium_proxy

      zenscrape_url = 'https://app.zenscrape.com/api/v1/get'

      api_request_options = {
        number_of_attempts: NUM_OF_INITIAL_ATTEMPTS,
        link: link,
        scraper: :zenscrape,
        raise_error_after_attempts: query[:premium_proxy] # only suppress error if non-premium (so we can try premium after)
      }

      res = ApiRequestService.call(api_request_options) do
        HTTParty.get(zenscrape_url, query: query, headers: headers)
      end

      return res if res

      # try the premium proxy if non-premium has failed
      query[:premium_proxy] = "true"

      api_request_options = {
        number_of_attempts: PREMIUM_ATTEMPTS,
        link: link,
        scraper: :zenscrape,
        raise_error_after_attempts: true
      }

      res = ApiRequestService.call(api_request_options) do
        HTTParty.get(zenscrape_url, query: query, headers: headers)
      end

      return res
    end
  end
end
