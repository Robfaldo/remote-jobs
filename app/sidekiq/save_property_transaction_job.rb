class SavePropertyTransactionJob
  include Sidekiq::Job

  def perform(*args)
    PropertyTransaction.create!(
      searched_url: args.first["searched_url"],
      searched_postcode: args.first["searched_postcode"],
      url: args.first["url"],
      address: args.first["address"],
      date_of_sale: args.first["date_of_sale"],
      num_of_bedrooms: args.first["num_of_bedrooms"],
      num_of_bathrooms: args.first["num_of_bathrooms"],
      property_type: args.first["property_type"],
      price: args.first["price"],
      key_features_json: args.first["key_features_json"]
    )
  end
end
