class AddSearchedLocationToScrapedJob < ActiveRecord::Migration[6.0]
  def change
    add_column(:scraped_jobs, :searched_location, :string)
  end
end
