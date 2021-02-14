require 'uri'
require 'net/http'
require 'net/https'

module Scraping
  class Luminati
    include ScrapingHelper

    def scrape_page(link:)
      # following: https://luminati.io/cp/api_example?example=main
      proxy_host = 'zproxy.lum-superproxy.io'
      proxy_port = '22225'
      proxy_user = 'lum-customer-c_f6cb99f4-zone-residential-route_err-pass_dyn-country-gb'
      proxy_pass = '3a90iifv02zf'

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
      response = HTTParty.get('https://www.httpbin.org/headers?json', options)
    end
  end
end
