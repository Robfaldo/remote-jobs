# API examples: https://luminati.io/cp/api_example?example=simple
module Scraping
  class Luminati
    class LuminatiError < StandardError; end
    class NotFoundResponse < StandardError; end
    class ApiErrorToRetry < StandardError; end
    include ScrapingHelper

    NUM_OF_INITIAL_ATTEMPTS = 1 # Unblocker should never fail so let's break & raise an error if it does.

    def initialize(api_key: ENV["LUMINATI_API_KEY"])
      raise LuminatiError.new("Missing ScrapingBee API key") unless ENV["LUMINATI_API_KEY"]

      @api_key = api_key
    end

    def scrape_page(link:)
      proxy_host = 'zproxy.lum-superproxy.io'
      proxy_port = '22225'
      proxy_user = 'lum-customer-c_f6cb99f4-zone-uk_data_unblock-country-gb-unblocker'
      proxy_pass = @api_key

      uri = URI.parse(link)
      proxy = Net::HTTP::Proxy(proxy_host, proxy_port, proxy_user, proxy_pass)

      NUM_OF_INITIAL_ATTEMPTS.times do |i|
        begin
          req = Net::HTTP::Get.new(uri.path)

          res = proxy.start(
            uri.host,
            uri.port,
            :use_ssl => uri.scheme == 'https',
            :verify_mode => OpenSSL::SSL::VERIFY_NONE
          ) do |http|
            http.request(req)
          end

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
    end
  end
end
