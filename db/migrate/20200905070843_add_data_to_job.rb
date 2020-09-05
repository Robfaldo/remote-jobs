class AddDataToJob < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :location, :string
    add_column :jobs, :longitude, :decimal
    add_column :jobs, :latitude, :decimal
  end
end
