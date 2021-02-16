# API examples: https://luminati.io/cp/api_example?example=simple
module Scraping
  class Luminati
    class LuminatiError < StandardError; end
    include ScrapingHelper

    NUM_OF_INITIAL_ATTEMPTS = 1 # Unblocker should never fail so let's break & raise an error if it does.

    def initialize(api_key: ENV["LUMINATI_API_KEY"])
      raise LuminatiError.new("Missing ScrapingBee API key") unless ENV["LUMINATI_API_KEY"]

      @api_key = api_key
    end

    def scrape_page(link:)
      proxy_host = 'zproxy.lum-superproxy.io'
      proxy_port = '22225'
      proxy_user = 'lum-customer-c_f6cb99f4-zone-uk_data_unblock-unblocker'
      proxy_pass = @api_key

      options = {
        http_proxyaddr: proxy_host,
        http_proxyport: proxy_port,
        http_proxyuser:proxy_user,
        http_proxypass: proxy_pass
      }

      # Will get an SSL error ("certificate verify failed (unable to get local issuer certificate)") without this. https://stackoverflow.com/a/25901450/5615805
      HTTParty::Basement.default_options.update(verify: false)

      NUM_OF_INITIAL_ATTEMPTS.times do |i|
        begin
          link = 'https://www.totaljobs.com/jobs/junior-and-developer/in-london?q=Junior+AND+Developer&radius=20'
          res = HTTParty.get(link, options)

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
