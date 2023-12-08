module Scraping
  module Property
    class SavePropertyTransactionsToCsv
      def self.call
        csv_file_path = "tmp/property_transactions_from_database#{DateTime.now}.csv"

        CSV.open(csv_file_path, "wb") do |csv|
          csv << ["Searched URL", "Searched Postcode", "URL", "Address", "Date of Sale", "Number of Bedrooms", "Number of Bathrooms", "Property Type", "Price", "Key Features"]
        end

        PropertyTransaction.all.each do |transaction|
          CSV.open(csv_file_path, "ab") do |csv|
            csv << [transaction.searched_url, transaction.searched_postcode, transaction.url,
                    transaction.address, transaction.date_of_sale, transaction.num_of_bedrooms,
                    transaction.num_of_bathrooms, transaction.property_type, transaction.price,
                    transaction.key_features_json]
          end
        end
      end
    end
  end
end