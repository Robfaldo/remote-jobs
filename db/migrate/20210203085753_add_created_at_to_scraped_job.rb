class AddCreatedAtToScrapedJob < ActiveRecord::Migration[6.0]
  def change
    add_column :scraped_jobs, :created_at, :datetime
  end
end
