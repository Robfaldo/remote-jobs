module Scraping
  class Luminati
    include ScrapingHelper
    class LuminatiError < StandardError; end

  NUM_OF_INITIAL_ATTEMPTS = 5

    def initialize(api_key: ENV["LUMINATI_API_KEY"])
      raise LuminatiError.new("Missing ScrapingBee API key") unless ENV["LUMINATI_API_KEY"]

      @api_key = api_key
    end

    def scrape_page(link:)
      # Guide for using puppeteer (node) with luminati: https://luminati.io/integration/puppeteer?cam=aw_lum-world-competitors_puppeteer_%2Bpuppeteer%20%2Bproxy_416465988232&utm_term=%2Bpuppeteer%20%2Bproxy&utm_campaign=competitors&utm_source=adwords&utm_medium=ppc&hsa_acc=1393175403&hsa_cam=1472134925&hsa_grp=94213721419&hsa_ad=416465988232&hsa_src=g&hsa_tgt=aud-410768889736:kwd-1062875403552&hsa_kw=%2Bpuppeteer%20%2Bproxy&hsa_mt=b&hsa_net=adwords&hsa_ver=3&utm_content=puppeteer&gclid=CjwKCAiAsaOBBhA4EiwAo0_AnJ_XDmHduDipOB142K43E3BeE5c_Pgtgj9PXF3gvnlQ8UX3lgqe3zxoCWtAQAvD_BwE
      # SO for using python: https://stackoverflow.com/questions/55644631/can-not-set-luminati-proxy-on-selenium-in-python-3
      # following: https://luminati.io/cp/api_example?example=main

      proxy_host = 'zproxy.lum-superproxy.io'
      proxy_port = '22225'
      proxy_user = 'lum-customer-c_f6cb99f4-zone-residential-route_err-pass_dyn-country-gb'
      proxy_pass = @api_key

      headers = {
        'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36',
        "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
        "Accept-Language" => "en-GB,en-US;q=0.9,en;q=0.8",
        "Upgrade-Insecure-Requests" => "1"
      }

      options = {
        http_proxyaddr: proxy_host,
        http_proxyport: proxy_port,
        http_proxyuser:proxy_user,
        http_proxypass: proxy_pass,
        headers: headers
      }

      NUM_OF_INITIAL_ATTEMPTS.times do |i|
        begin
          binding.pry
          res = HTTParty.get(link, options)

          binding.pry

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
