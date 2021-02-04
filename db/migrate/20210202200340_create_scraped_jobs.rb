class CreateScrapedJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :scraped_jobs do |t|
      t.string :title
      t.string :link
      t.string :location
      t.string :company
    end
  end
end
