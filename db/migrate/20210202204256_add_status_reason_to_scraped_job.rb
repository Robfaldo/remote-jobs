class AddStatusReasonToScrapedJob < ActiveRecord::Migration[6.0]
  def change
    add_column :scraped_jobs, :status_reason, :string
  end
end
