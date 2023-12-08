class CreatePropertyTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :property_transactions do |t|
      t.string :searched_url
      t.string :searched_postcode
      t.string :url
      t.string :address
      t.string :date_of_sale
      t.integer :num_of_bedrooms
      t.integer :num_of_bathrooms
      t.string :property_type
      t.integer :price
      t.string :key_features_json

      t.timestamps
    end
  end
end
