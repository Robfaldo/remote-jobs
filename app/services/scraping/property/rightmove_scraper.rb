module Scraping
  module Property
    class RightmoveScraper
      include ScrapingHelper

      def initialize
        # original one with all of the ones under 1k
        # See the rightmove_postcode_checker for the csv generated which identifies these
        # @top_level_postcodes_with_under_1k_sold_properties = ['EH31', 'EH44', 'EH46', 'EH28', 'EH27', 'EH2', 'EH18', 'EH40', 'EH34', 'EH24', 'EH35', 'EH37', 'EH43', 'EH38', 'EH36']

        # The first one i ran (with the first few postcodes from the full list), filename: rightmove_top_level_postcode_properties_UNDER_1K2023-12-05T14:09:40+00:00.csv
        # @top_level_postcodes_with_under_1k_sold_properties = ['EH31', 'EH44', 'EH46', 'EH28', 'EH27', 'EH2', 'EH18']

        # The second one I ran (with the rest of the postcodes from the full list), filename: rightmove_top_level_postcode_properties_UNDER_1K2023-12-05T21:03:03+00:00.csv
        # @top_level_postcodes_with_under_1k_sold_properties = ['EH40', 'EH34', 'EH24', 'EH35', 'EH37', 'EH43', 'EH38', 'EH36']

        # Filename:
        @bottom_level_postcodes = read_bottom_level_postcodes

        @scraper = Scraping::Scrapers::ScrapingBee.new
        @csv_file_path = "tmp/rightmove_top_level_postcode_properties_OVER_1K#{DateTime.now}.csv"
        create_csv
      end

      def call
        @bottom_level_postcodes.each do |postcode|
          first_page = scraper.scrape_page(
            wait_time: 1000,
            link: all_properties_link(postcode, 1),
            javascript_scenario: javascript
          )
          total_pages_count = first_page.at('.pagination-current .pagination-label:last-child')&.text&.strip&.gsub("of ", "")&.to_i || 1

          total_pages_count.times do |index|
            # It's 0 indexed so just bumping 1 to represent actual page (e.g. first page is 1 and not 0)
            page_number = index + 1

            if page_number == 1 # we've already scraped first page so lets avoid doing it again
              add_first_page_properties_to_csv(first_page, postcode)
            else
              add_other_page_properties_to_csv(page_number, postcode)
            end
          end
        rescue Scrapers::ScrapingBee::ScrapingBeeError => e
          next
        end
      rescue => e
        binding.pry
      end

      private

      attr_reader :scraper, :csv_file_path

      def add_first_page_properties_to_csv(page, postcode)
        link = all_properties_link(postcode, 1)
        scraped_properties = page.css('.propertyCard')
        add_properties_to_csv(scraped_properties, link, postcode)
      end

      def add_other_page_properties_to_csv(page_number, postcode)
        link =  all_properties_link(postcode, page_number)
        page = scraper.scrape_page(
          wait_time: 1000,
          link: link,
          javascript_scenario: javascript
        )
        scraped_properties = page.css('.propertyCard')
        add_properties_to_csv(scraped_properties, link, postcode)
      end

      def all_properties_link(postcode, page)
        "https://www.rightmove.co.uk/house-prices/#{postcode}.html?propertyCategory=RESIDENTIAL&page=#{page}"
      end


      def create_csv
        CSV.open(csv_file_path, "wb") do |csv|
          csv << ["Searched URL", "Searched Postcode", "URL", "Address", "Date of Sale", "Number of Bedrooms", "Number of Bathrooms", "Property Type", "Price", "Key Features"]
        end
      end

      def add_properties_to_csv(scraped_properties, searched_url, searched_postcode)
        scraped_properties.each do |scraped_property|
          url = scraped_property.at('.title.clickable')['href']
          bedrooms_matches = scraped_property.css(".bedrooms")&.text&.match(/(\d+)\s*bed/)
          num_of_bedrooms = bedrooms_matches ? bedrooms_matches[1].to_i : "Unknown"
          address = scraped_property.at('.title.clickable').text
          transactions = scraped_property.css('.transaction-table', '.row')
          property_type = "Unknown"
          num_of_bathrooms = "Unknown"
          key_features_json = "Unknown"

          if num_of_bedrooms != "Unknown"
            property_details_page = scraper.scrape_page(
              wait_time: 1000,
              link: url
            )
            property_type = property_details_page.xpath("//p[contains(., 'type of property')]")&.first&.text&.gsub("type of property ", "") || "Unknown"
            num_of_bathrooms = property_details_page.xpath("//p[contains(., 'number of bathrooms')]")&.first&.text&.gsub("number of bathrooms ×", "") || "Unknown"
            key_features_section = property_details_page.at_xpath('//h2[contains(text(), "Key features")]/following-sibling::ul')
            key_features = key_features_section&.xpath('.//li')&.map(&:text)
            key_features_json = key_features && JSON.generate(key_features)
          end

          # for some reason (can't work out why) the first transaction is duplicated so i'll only use unique ones based on the text of the element
          unique_transactions = transactions.uniq do |transaction|
            transaction.at_css('.date-sold').text.strip
          end

          unique_transactions.each do |transaction|
            date_of_sale = transaction.at_css('.date-sold').text.strip
            price = transaction.at_css('.price').text.strip.gsub("£", "").gsub(",", "")

            add_property_to_csv(searched_url, searched_postcode, url, address, date_of_sale, num_of_bedrooms, num_of_bathrooms, property_type, price, key_features_json)
          end
        end
      end

      def add_property_to_csv(searched_url, searched_postcode, url, address, date_of_sale, num_of_bedrooms, num_of_bathrooms, property_type, price, key_features)
        CSV.open(csv_file_path, "ab") do |csv|
          csv << [searched_url, searched_postcode, url, address, date_of_sale, num_of_bedrooms, num_of_bathrooms, property_type, price, key_features]
        end
      end

      def read_bottom_level_postcodes
        file_path = 'tmp/edinburgh_postcode_retriever2023-11-24T17:05:37+00:00.csv'
        postcodes = []

        CSV.foreach(file_path, headers: true) do |row|
          # Add the postcode from each row to the array
          postcodes << row['Postcode'].gsub(" ","")
        end

        postcodes
      end

      def javascript
        click_all_extend_toggles = %{
          document.querySelectorAll('.expand-toggle').forEach(function(element) {
              element.click();
          });
        }

        {
          instructions: [
            { wait: 200 },
            { evaluate: click_all_extend_toggles },
            { wait: 1000 }
          ]
        }
      end
    end
  end
end