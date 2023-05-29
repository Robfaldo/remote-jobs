class AddFilteredToScrapedJob < ActiveRecord::Migration[7.0]
  def change
    add_column :scraped_jobs, :filtered, :boolean, default: false
  end
end
