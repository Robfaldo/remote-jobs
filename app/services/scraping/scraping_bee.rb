module Scraping
  class ScrapingBee
    class ScrapingBeeError < StandardError; end
    include ScrapingHelper

    NUM_OF_INITIAL_ATTEMPTS = 5
    PREMIUM_ATTEMPTS = 2

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
      NUM_OF_INITIAL_ATTEMPTS.times do |i|
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
        rescue => e
          sleep 5
          next # to retry go to the next iteration of the loop
        end
      end

      if query[:premium_proxy]
        raise ScrapingBeeError.new("#{NUM_OF_INITIAL_ATTEMPTS} Premium proxy attempts failed. Query: #{query.to_s}")
      else
        # If the above attempts fail and a non-premium proxy was used, try X times with premium proxy
        query[:premium_proxy] = "true"

        PREMIUM_ATTEMPTS.times do |i|
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

            raise ScrapingBeeError.new(e_message) if (i + 1) == PREMIUM_ATTEMPTS # i + 1 because i is 0 indexed
            next # to retry go to the next iteration of the loop
          rescue NotFoundResponse => e
            code = e.message.split('##SPLITHERE##')[0]
            body = e.message.split('##SPLITHERE##')[1]
            raise ScrapingBeeError.new("404 was returned by ScrapingBee. Link: #{link}. Last response code: #{code}. Last response body: #{body}")
          rescue => e
            sleep 5
            next # to retry go to the next iteration of the loop
          end
        end
      end
    end
  end
end
