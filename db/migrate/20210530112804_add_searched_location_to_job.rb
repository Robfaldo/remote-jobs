class AddSearchedLocationToJob < ActiveRecord::Migration[6.0]
  def change
    add_column(:jobs, :searched_location, :string)
  end
end
