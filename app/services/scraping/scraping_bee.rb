module Scraping
  class ScrapingBee
    class ScrapingBeeError < StandardError; end
    class NotFoundResponse < StandardError; end
    class ApiErrorToRetry < StandardError; end

    def initialize(api_key: ENV["SCRAPING_BEE_KEY"])
      raise ScrapingBeeError.new("Missing ScrapingBee API key") unless ENV["SCRAPING_BEE_KEY"]

      @api_key = api_key
    end

    def scrape_page(link:, javascript_snippet:, wait_time:, custom_google:, premium_proxy:)
      uri_string = 'https://app.scrapingbee.com/api/v1/?'
      uri_string << 'api_key=' + @api_key
      uri_string << "&url=#{CGI.escape(link)}"
      uri_string << "&wait=" + wait_time.to_s
      uri_string << "&premium_proxy=true" if premium_proxy
      uri_string << "&country_code=gb" if premium_proxy
      uri_string << "&js_snippet=#{Base64.strict_encode64(javascript_snippet)}" if javascript_snippet
      uri_string << "&custom_google=True" if custom_google
      uri = URI(uri_string)

      # Create client
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 120
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      # Create Request
      req = Net::HTTP::Get.new(uri)

      # X attempts using the requested (premium/non-premium) proxy
      5.times do |i|
        begin
          res = http.request(req)
          puts "Attempt #{i + 1}: Response HTTP Status Code: #{ res.code }"
          puts "Attempt #{i + 1}: Response HTTP Response Body: #{ res.body }"
          return res if res.code == "200"

          if res.code == "404"
            raise NotFoundResponse.new("#{res.code}##SPLITHERE###{res.body}")
          else
            raise ApiErrorToRetry.new
          end
        rescue ApiErrorToRetry
          next # to retry go to the next iteration of the loop
        rescue NotFoundResponse => e
          code = e.message.split('##SPLITHERE##')[0]
          body = e.message.split('##SPLITHERE##')[1]
          raise ScrapingBeeError.new("404 was returned by ScrapingBee. Link: #{link}. URI String: #{uri_string}. Last response code: #{code}. Last response body: #{body}")
        end
      end

      premium_proxy_attempted = false
      second_premium_proxy_attempted = false

      # If the above attempts fail and a non-premium proxy was used, try X times with premium proxy
      if !premium_proxy
        uri_string << "&premium_proxy=true"
        uri = URI(uri_string)

        # Create client
        http = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = 120
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        # Create Request
        req = Net::HTTP::Get.new(uri)

        premium_proxy_attempts = 2

        premium_proxy_attempts.times do |i|
          begin
            res = http.request(req)
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
            e_message = "Could not scrape after 5 attempts using #{premium_proxy ? "premium" : "non-premium"} Proxy.#{premium_proxy_attempts} Premium proxies attempted. Link: #{link}. URI String: #{uri_string}. Last response code: #{code}. Last response body: #{body}"

            raise ScrapingBeeError.new(e_message) if i == premium_proxy_attempted - 1 # minus 1 because i is 0 indexed
            next # to retry go to the next iteration of the loop
          rescue NotFoundResponse => e
            code = e.message.split('##SPLITHERE##')[0]
            body = e.message.split('##SPLITHERE##')[1]
            raise ScrapingBeeError.new("404 was returned by ScrapingBee. Link: #{link}. URI String: #{uri_string}. Last response code: #{code}. Last response body: #{body}")
          end
        end
      end
    end
  end
end
