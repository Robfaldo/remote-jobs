module Scraping
  class ScrapingBee
    class ScrapingBeeError < StandardError; end
    class NotFoundResponse < StandardError; end
    class ApiErrorToRetry < StandardError; end
    include ScrapingHelper

    def initialize(api_key: ENV["SCRAPING_BEE_KEY"])
      raise ScrapingBeeError.new("Missing ScrapingBee API key") unless ENV["SCRAPING_BEE_KEY"]

      @api_key = api_key
    end

    def scrape_page(link:, javascript_snippet:, wait_time:, custom_google:, premium_proxy:)
      query = {
          api_key: @api_key,
          url: link, # removed CGI.escape() recently (in case debugging)
          wait: wait_time.to_s
      }
      query[:premium_proxy] = "true" if premium_proxy
      query[:country_code] = "gb" if premium_proxy
      query[:js_snippet] = Base64.strict_encode64(javascript_snippet) if javascript_snippet
      query[:custom_google] = "true" if custom_google

      scraping_bee_url = 'https://app.scrapingbee.com/api/v1/'

      # X attempts using the requested (premium/non-premium) proxy
      5.times do |i|
        begin
          res = HTTParty.get(scraping_bee_url,
                             query: query)

          puts "Attempt #{i + 1}: Response HTTP Status Code: #{ res.code }"
          puts "Attempt #{i + 1}: Response HTTP Response Body: #{ res.body }"
          return res if res.code == 200

          if res.code == 404
            raise NotFoundResponse.new("#{res.code}##SPLITHERE###{res.body}")
          else
            raise ApiErrorToRetry.new
          end
        rescue ApiErrorToRetry
          next # to retry go to the next iteration of the loop
        rescue NotFoundResponse => e
          code = e.message.split('##SPLITHERE##')[0]
          body = e.message.split('##SPLITHERE##')[1]
          raise ScrapingBeeError.new("404 was returned by ScrapingBee. Link: #{link}. Last response code: #{code}. Last response body: #{body}")
        end
      end

      # If the above attempts fail and a non-premium proxy was used, try X times with premium proxy
      unless query[:premium_proxy]
        query[:premium_proxy] = "true"

        premium_proxy_attempts = 2

        premium_proxy_attempts.times do |i|
          begin
            res = HTTParty.get(scraping_bee_url,
                               query: query)

            puts "Re-attempt with premium proxy: #{i}: Response HTTP Status Code: #{ res.code }"
            puts "Re-attempt with premium proxy: #{i}: Response HTTP Response Body: #{ res.body }"
            return res if res.code == 200

            if res.code == 404
              raise NotFoundResponse.new("#{res.code}##SPLITHERE###{res.body}")
            else
              raise ApiErrorToRetry.new("#{res.code}##SPLITHERE###{res.body}")
            end
          rescue ApiErrorToRetry => e
            code = e.message.split('##SPLITHERE##')[0]
            body = e.message.split('##SPLITHERE##')[1]
            e_message = "Could not scrape after 2 additional attempts using. Link: #{link}. Last response code: #{code}. Last response body: #{body}"

            raise ScrapingBeeError.new(e_message) if (i + 1) == premium_proxy_attempts # i + 1 because i is 0 indexed
            next # to retry go to the next iteration of the loop
          rescue NotFoundResponse => e
            code = e.message.split('##SPLITHERE##')[0]
            body = e.message.split('##SPLITHERE##')[1]
            raise ScrapingBeeError.new("404 was returned by ScrapingBee. Link: #{link}. Last response code: #{code}. Last response body: #{body}")
          end
        end
      end
    end
  end
end
