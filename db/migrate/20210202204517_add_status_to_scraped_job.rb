class AddStatusToScrapedJob < ActiveRecord::Migration[6.0]
  def change
    add_column :scraped_jobs, :status, :string
  end
end
