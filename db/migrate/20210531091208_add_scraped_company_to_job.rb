class AddScrapedCompanyToJob < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :scraped_company, :string
  end
end
