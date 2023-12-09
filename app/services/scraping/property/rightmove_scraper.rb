module Scraping
  module Property
    class RightmoveScraper
      include ScrapingHelper

      def initialize
        @bottom_level_postcodes = read_bottom_level_postcodes

        @scraper = Scraping::Scrapers::ScrapingBee.new
      end

      def call
        # Creating a thread-safe Queue
        work_queue = Queue.new

        # all the bottom level postcodes (the top level postcodes that had over 1k listings broken down into bottom level ones)
        # @bottom_level_postcodes.each { |item| work_queue << item }

        # all of the top level postcodes with ones under 1k listings (so can scrape all without breaking up)
        # See the rightmove_postcode_checker for the csv generated which identifies these
        ['EH31', 'EH44', 'EH46', 'EH28', 'EH27', 'EH2', 'EH18', 'EH40', 'EH34', 'EH24', 'EH35', 'EH37', 'EH43', 'EH38', 'EH36'].each { |item| work_queue << item }

        # Process in parallel
        Parallel.each(1..100, in_threads: 100) do
          until work_queue.empty?
            postcode = work_queue.pop(true) rescue nil
            next unless postcode

            perform_scraping(postcode)
          end
        end
      end

      private

      attr_reader :scraper, :csv_file_path

      def perform_scraping(postcode)
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
            create_property_transactions_from_first_page(first_page, postcode)
          else
            create_property_transactions_from_other_page(page_number, postcode)
          end
        end
      rescue Scrapers::ScrapingBee::ScrapingBeeError => e
        nil
      rescue => e
        binding.pry
      end

      def create_property_transactions_from_first_page(page, postcode)
        link = all_properties_link(postcode, 1)
        scraped_properties = page.css('.propertyCard')
        create_properties(scraped_properties, link, postcode)
      end

      def create_property_transactions_from_other_page(page_number, postcode)
        link =  all_properties_link(postcode, page_number)
        page = scraper.scrape_page(
          wait_time: 1000,
          link: link,
          javascript_scenario: javascript
        )
        scraped_properties = page.css('.propertyCard')
        create_properties(scraped_properties, link, postcode)
      end

      def all_properties_link(postcode, page)
        "https://www.rightmove.co.uk/house-prices/#{postcode}.html?propertyCategory=RESIDENTIAL&page=#{page}"
      end

      def create_properties(scraped_properties, searched_url, searched_postcode)
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

            SavePropertyTransactionJob.perform_async(
              "searched_url" => searched_url,
              "searched_postcode" => searched_postcode,
              "url" => url,
              "address" => address,
              "date_of_sale" => date_of_sale,
              "num_of_bedrooms" => num_of_bedrooms,
              "num_of_bathrooms" => num_of_bathrooms,
              "property_type" => property_type,
              "price" => price,
              "key_features_json" => key_features_json
            )
          end
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