class AddFieldsToCompany < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :careers_page_url, :string
    add_column :companies, :scraper_class, :string
  end
end
