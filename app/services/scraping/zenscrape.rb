module Scraping
  class Zenscrape
    class ZenscrapeError < StandardError; end
    class NotFoundResponse < StandardError; end
    class ApiErrorToRetry < StandardError; end
    include ScrapingHelper

    def initialize(api_key: ENV["ZENSCRAPE_API_KEY"])
      raise ZenscrapeError.new("Missing ZenscrapeError API key") unless ENV["ZENSCRAPE_API_KEY"]

      @api_key = api_key
    end

    def scrape_page(link:, wait_time:, premium_proxy:)
      headers = {
        apikey: @api_key
      }

      query = {
        url: link,
        wait_for: (wait_time/1000).to_s, # send in seconds, not milliseconds
        block_resources: 'stylesheet,image,media', # I could add more here
        render: "true" # this costs 5 credits and could sometimes be skipped (future optimisation)
      }

      query[:premium_proxy] = "true" if premium_proxy
      query[:country] = "uk" if premium_proxy

      zenscrape_url = 'https://app.zenscrape.com/api/v1/get'

      # X attempts using the requested (premium/non-premium) proxy
      5.times do |i|
        begin
          res = HTTParty.get(zenscrape_url,
                             query: query,
                             headers: headers)

          puts "Attempt #{i + 1}: Response HTTP Status Code: #{ res.code }"
          puts "Attempt #{i + 1}: Response HTTP Response Body: #{ res.body }"
          return res if res.code == "200"

          if res.code == "404"
            raise NotFoundResponse.new("#{res.code}##SPLITHERE###{res.body}")
          else
            raise ApiErrorToRetry.new
          end
        rescue ApiErrorToRetry
          binding.pry
          next # to retry go to the next iteration of the loop
        rescue NotFoundResponse => e
          code = e.message.split('##SPLITHERE##')[0]
          body = e.message.split('##SPLITHERE##')[1]
          raise ZenscrapeError.new("404 was returned by Zenscrape. Link: #{link}. Last response code: #{code}. Last response body: #{body}")
        end
      end

      # If the above attempts fail and a non-premium proxy was used, try X times with premium proxy
      unless query[:premium_proxy]
        query[:premium_proxy] = "true"

        premium_proxy_attempts = 2

        premium_proxy_attempts.times do |i|
          begin
            res = HTTParty.get(zenscrape_url,
                               query: query,
                               headers: headers)

            puts "Re-attempt with premium proxy: #{i}: Response HTTP Status Code: #{ res.code }"
            puts "Re-attempt with premium proxy: #{i}: Response HTTP Response Body: #{ res.body }"
            return res if res.code == "200"

            if res.code == "404"
              raise NotFoundResponse.new("#{res.code}##SPLITHERE###{res.body}")
            else
              raise ApiErrorToRetry.new("#{res.code}##SPLITHERE###{res.body}")
            end
          rescue ApiErrorToRetry
            code = e.message.split('##SPLITHERE##')[0]
            body = e.message.split('##SPLITHERE##')[1]
            e_message = "Could not scrape after 2 additional attempts using. Link: #{link}. Last response code: #{code}. Last response body: #{body}"

            raise ZenscrapeError.new(e_message) if i == premium_proxy_attempted - 1 # minus 1 because i is 0 indexed
            next # to retry go to the next iteration of the loop
          rescue NotFoundResponse => e
            code = e.message.split('##SPLITHERE##')[0]
            body = e.message.split('##SPLITHERE##')[1]
            raise ZenscrapeError.new("404 was returned by Zenscrape. Link: #{link}. Last response code: #{code}. Last response body: #{body}")
          end
        end
      end
    end
  end
end
