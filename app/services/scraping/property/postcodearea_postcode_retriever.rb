module Scraping
  module Property
    class PostcodeareaPostcodeRetriever
      include ScrapingHelper

      # We don't include top level postcodes that have under 1k properties sold because
      # we won't need to break those down and can just scrape them from rightmove directly
      TOP_LEVEL_POSTCODES_THAT_HAVE_OVER_1K_PROPERTIES_SOLD = ['EH6',  'EH4',  'EH7',  'EH11',  'EH12',  'EH54',  'EH48',  'EH14',  'EH3',  'EH10',  'EH16',  'EH22',  'EH21',  'EH5',  'EH8',  'EH15',  'EH9',  'EH47',  'EH17',  'EH52',  'EH32',  'EH19',  'EH49',  'EH26',  'EH51',  'EH41',  'EH42',  'EH13',  'EH53',  'EH33',  'EH39',  'EH45',  'EH30',  'EH23',  'EH55',  'EH20',  'EH29',  'EH25']

      def initialize
        @scraper = Scraping::Scrapers::ScrapingBee.new
        @csv_file_path = "tmp/edinburgh_postcode_retriever#{DateTime.now}.csv"
        create_csv
      end

      # Calling this will generate a csv where TBC
      def call
        TOP_LEVEL_POSTCODES_THAT_HAVE_OVER_1K_PROPERTIES_SOLD.each do |top_level_postcode|
          top_level_page = scraper.scrape_page(
            wait_time: 5000,
            link: "https://www.postcodearea.co.uk/postaltowns/edinburgh/#{top_level_postcode.downcase}/"
          )

          bottom_level_postcodes = top_level_page.css(".tab-content", ".tab-pane",  "a").select{|el| el.text.start_with?("EH") && el.text.length < 12}.reject{|el| el.text.end_with?("..")}.map{|el| el.text}

          bottom_level_postcodes.each do |bottom_level_postcode|
            CSV.open(csv_file_path, "ab") do |csv|
              csv << [top_level_postcode, bottom_level_postcode]
            end
          end
        end
      rescue => e
        binding.pry
      end

      private

      attr_reader :scraper, :csv_file_path

      def create_csv
        CSV.open(csv_file_path, "wb") do |csv|
          csv << ["Top level postcode", "Postcode"]
        end
      end
    end
  end
end

# Postcodes: https://www.postcodearea.co.uk/postaltowns/edinburgh/