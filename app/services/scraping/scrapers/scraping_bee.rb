module Scraping
  module Scrapers
    class ScrapingBee
      class ScrapingBeeError < StandardError; end
      class NotFoundResponse < StandardError; end
      class ApiErrorToRetry < StandardError; end
      include ScrapingHelper

      NUMBER_OF_INITIAL_ATTEMPTS = 10
      NUMBER_OF_STEALTH_ATTEMPTS = 20
      SCRAPING_BEE_URL = 'https://app.scrapingbee.com/api/v1/'

      def initialize(api_key: ENV["SCRAPING_BEE_KEY"])
        raise ScrapingBeeError.new("Missing ScrapingBee API key") unless ENV["SCRAPING_BEE_KEY"]

        @api_key = api_key
      end

      def scrape_page(link:,
                      javascript_snippet: nil,
                      wait_time: nil,
                      custom_google: false,
                      allow_css_and_images: false,
                      wait_browser: nil,
                      javascript_scenario: nil)
        query = {
          api_key: @api_key,
          url: link,
        }
        query[:wait] = wait_time.to_s if wait_time
        query[:premium_proxy] = "true"
        query[:country_code] = "gb"

        # TODO: I think js_snippet has been deprecrated (replaced by js_scenario) and I
        # think i can remove it
        query[:js_snippet] = Base64.strict_encode64(javascript_snippet) if javascript_snippet
        query[:js_scenario] = javascript_scenario.to_json if javascript_scenario

        query[:custom_google] = "true" if custom_google
        query[:block_resources] = false if allow_css_and_images
        query[:wait_browser] = wait_browser if wait_browser
        # for debugging to save a screenshot instead of responding with html
        # query[:screenshot_full_page] = true

        response = send_request_to_scraping_bee(query, NUMBER_OF_INITIAL_ATTEMPTS)
        if response_was_successful?(response)
          nokogiri_page = parsed_nokogiri_html(response.body)
          # for debugging
          # binding.pry
          # save_screenshot(response) # (make sure the screenshot param is being passed to scrapingbee)
          # nokogiri_page.xpath('//script').remove # removing javascript from the page is optional
          # save_page(nokogiri_page)
          return nokogiri_page
        end

        msg = "#{NUMBER_OF_INITIAL_ATTEMPTS} Premium proxy attempts failed. Query: #{query.to_s}"
        SendToErrorMonitors.send_notification(message: msg)

        query[:stealth_proxy] = "true"
        response = send_request_to_scraping_bee(query, NUMBER_OF_STEALTH_ATTEMPTS)

        if response_was_successful?(response)
          # binding.pry
          return parsed_nokogiri_html(response.body)
        end

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

          # for debugging
          # binding.pry
          # save_screenshot(res) # (make sure the screenshot param is being passed to scrapingbee)
          # save_page(nokogiri_page)
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
