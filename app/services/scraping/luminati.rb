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
      session = Random.rand(100000)

      uri = URI.parse(URI::encode("https://www.totaljobs.com/"))
      headers = {
        'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36',
        "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
        "Accept-Language" => "en-GB,en-US;q=0.9,en;q=0.8",
        "Upgrade-Insecure-Requests" => "1"
      }

      proxy = Net::HTTP::Proxy(proxy_host, proxy_port, "#{proxy_user}", proxy_pass)
      http = proxy.new(uri.host,uri.port)

      if uri.scheme == 'https'
        http.use_ssl = true
      end

      req = Net::HTTP::Get.new(uri.path, headers)

      result = http.start do |con|
        con.request(req)
      end

      page = Nokogiri::HTML.parse(result.body)
      binding.pry

    end
  end
end
