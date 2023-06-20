module Scraping
  module Scrapers
    class ScrapingBee
      class ScrapingBeeError < StandardError; end
      class NotFoundResponse < StandardError; end
      class ApiErrorToRetry < StandardError; end
      include ScrapingHelper

      NUMBER_OF_INITIAL_ATTEMPTS = 10
      NUMBER_OF_STEALTH_ATTEMPTS = 5
      SCRAPING_BEE_URL = 'https://app.scrapingbee.com/api/v1/'

      def initialize(api_key: ENV["SCRAPING_BEE_KEY"])
        raise ScrapingBeeError.new("Missing ScrapingBee API key") unless ENV["SCRAPING_BEE_KEY"]

        @api_key = api_key
      end

      def scrape_page(link:,
                      javascript_snippet: nil,
                      wait_time: 5000,
                      custom_google: false,
                      allow_css_and_images: false)
        query = {
          api_key: @api_key,
          url: link,
          wait: wait_time.to_s
        }
        query[:premium_proxy] = "true"
        query[:country_code] = "gb"
        query[:js_snippet] = Base64.strict_encode64(javascript_snippet) if javascript_snippet
        query[:custom_google] = "true" if custom_google
        query[:block_resources] = false if allow_css_and_images
        # for debugging to save a screenshot instead of responding with html
        # query[:screenshot_full_page] = true

        response = send_request_to_scraping_bee(query, NUMBER_OF_INITIAL_ATTEMPTS)
        return parsed_nokogiri_html(response.body) if response_was_successful?(response)

        msg = "#{NUMBER_OF_INITIAL_ATTEMPTS} Premium proxy attempts failed. Query: #{query.to_s}"
        SendToErrorMonitors.send_notification(message: msg)

        query[:stealth_proxy] = "true"
        response = send_request_to_scraping_bee(query, NUMBER_OF_STEALTH_ATTEMPTS)

        return parsed_nokogiri_html(response.body) if response_was_successful?(response)

        msg = "#{NUMBER_OF_STEALTH_ATTEMPTS} Stealth proxy attempts failed. Query: #{query.to_s}"
        raise ScrapingBeeError.new(msg)
      end

      private

      def send_request_to_scraping_bee(query, number_of_attempts)
        number_of_attempts.times do |i|
          res = HTTParty.get(SCRAPING_BEE_URL,
                             query: query)

          puts "Attempt #{i + 1}: Response HTTP Status Code: #{ res.code }"
          puts "Attempt #{i + 1}: Response HTTP Response Body: #{ res.body }"

          # for debugging you can save the screenshot to a file (requires the screenshot_full_page query above)
          # save_screenshot(res)
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

        # If res.code is not 200 for any attempt then scraping is not successful
        :scraping_unsuccessful
      end

      def parsed_nokogiri_html(response_body)
        Nokogiri::HTML.parse(response_body)
      rescue Exception
        # https://stackoverflow.com/a/4789702/5615805
        raise $!, "Error parsing response. Response: #{response}. Link: #{link}", $!.backtrace
      end

      def response_was_successful?(response)
        response != :scraping_unsuccessful
      end
    end
  end
end
