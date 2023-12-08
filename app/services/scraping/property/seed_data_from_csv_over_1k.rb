module Scraping
  module Property
    class SeedDataFromCsvOver1k
      FILE_PATH = 'tmp/rightmove_top_level_postcode_properties_OVER_1K2023-12-06T22:17:08+00:00.csv'

      def self.call
        CSV.foreach(FILE_PATH, headers: true) do |row|
          SavePropertyTransactionJob.perform_async(
            "searched_url" => row['Searched URL'],
            "searched_postcode" => row['Searched Postcode'],
            "url" => row["URL"],
            "address" => row["Address"],
            "date_of_sale" => row["Date of Sale"],
            "num_of_bedrooms" => row["Number of Bedrooms"],
            "num_of_bathrooms" => row["Number of Bathrooms"],
            "property_type" => row["Property Type"],
            "price" => row["Price"],
            "key_features_json" => row["Key Features"]
          )
        end
      end
    end
  end
end