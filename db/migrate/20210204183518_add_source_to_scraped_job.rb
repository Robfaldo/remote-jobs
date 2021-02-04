class AddSourceToScrapedJob < ActiveRecord::Migration[6.0]
  def change
    add_column :scraped_jobs, :source, :string
  end
end
