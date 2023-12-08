module Scraping
  module Property
    class RightmovePostcodeChecker
      include ScrapingHelper

      # These are all top level postcodes for edinburgh (see https://www.postcodearea.co.uk/postaltowns/edinburgh/)
      POSTCODES = ["EH10", "EH11", "EH12", "EH13", "EH14", "EH15", "EH16", "EH17", "EH18", "EH19", "EH2", "EH20", "EH21", "EH22", "EH23", "EH24", "EH25", "EH26", "EH27", "EH28", "EH29", "EH3", "EH30", "EH31", "EH32", "EH33", "EH34", "EH35", "EH36", "EH37", "EH38", "EH39", "EH4", "EH40", "EH41", "EH42", "EH43", "EH44", "EH45", "EH46", "EH47", "EH48", "EH49", "EH5", "EH51", "EH52", "EH53", "EH54", "EH55", "EH6", "EH7", "EH8", "EH9"]

      def initialize
        @scraper = Scraping::Scrapers::ScrapingBee.new
        @csv_file_path = "tmp/postcode_data#{DateTime.now}.csv"
        create_csv
      end

      # Running this will generate a CSV where you can see how many properties sold for each top level postcode
      # We do this because if the properties sold are over 1000 then we need to break the top level postcode down
      # because rightmove only lets you do 40 pages of results (with 25 properties per page which = 1000 properties total)
      def call
        POSTCODES.each do |postcode|
          page = scraper.scrape_page(
            wait_time: 5000,
            link: "https://www.rightmove.co.uk/house-prices/#{postcode}.html?propertyCategory=RESIDENTIAL&page=1"
          )

          total_sold_properties = page.at('.sort-bar-results').text.split("sold").first.strip.gsub(",", "")

          CSV.open(csv_file_path, "ab") do |csv|
            csv << [postcode, total_sold_properties]
          end
        end
      rescue => e
        binding.pry
      end

      private

      attr_reader :scraper, :csv_file_path

      def create_csv
        CSV.open(csv_file_path, "wb") do |csv|
          csv << ["Postcode", "Total results"]
        end
      end
    end
  end
end

# Postcodes: https://www.postcodearea.co.uk/postaltowns/edinburgh/