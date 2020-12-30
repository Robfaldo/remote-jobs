module Scraping
  class ScrapingBee
    class ScrapingBeeError < StandardError; end

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
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      # Create Request
      req =  Net::HTTP::Get.new(uri)

      # Fetch Request
      res = http.request(req)
      puts "1st Response HTTP Status Code: #{ res.code }"
      puts "1st Response HTTP Response Body: #{ res.body }"
      return res if res.code == "200"

      res = http.request(req)
      puts "2nd Response HTTP Status Code: #{ res.code }"
      puts "2nd Response HTTP Response Body: #{ res.body }"
      return res if res.code == "200"

      res = http.request(req)
      puts "3rd Response HTTP Status Code: #{ res.code }"
      puts "3rd Response HTTP Response Body: #{ res.body }"
      return res if res.code == "200"

      res = http.request(req)
      puts "4th Response HTTP Status Code: #{ res.code }"
      puts "4th Response HTTP Response Body: #{ res.body }"
      return res if res.code == "200"

      res = http.request(req)
      puts "5th Response HTTP Status Code: #{ res.code }"
      puts "5th Response HTTP Response Body: #{ res.body }"
      return res if res.code == "200"

      e_message = "Could not scrape after 5 attempts. Link: #{link}. URI String: #{uri_string}. Last response code: #{res.code}. Last response body: #{res.body}"

      raise ScrapingBeeError.new(e_message)
    rescue StandardError => e
      Rollbar.error(e)

      puts "HTTP Request failed (#{ e.message })"
    end
  end
end
