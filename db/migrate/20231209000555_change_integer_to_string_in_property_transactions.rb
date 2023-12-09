class ChangeIntegerToStringInPropertyTransactions < ActiveRecord::Migration[7.0]
  def change
    change_column :property_transactions, :num_of_bedrooms, :string
    change_column :property_transactions, :num_of_bathrooms, :string
    change_column :property_transactions, :price, :string
  end
end
