module Scraping
  class ScrapingBee
    def initialize(api_key:)
      @api_key = api_key
    end

    def scrape_page(link:, javascript_snippet: nil, wait_time: 10000, custom_google: false)
      uri_string = 'https://app.scrapingbee.com/api/v1/?'
      uri_string << 'api_key=' + @api_key
      uri_string << "&url=#{CGI.escape(link)}"
      uri_string << "&wait=" + wait_time.to_s
      uri_string << "&premium_proxy=true"
      uri_string << "&country_code=gb"
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
    rescue StandardError => e
      puts "HTTP Request failed (#{ e.message })"
    end
  end
end
