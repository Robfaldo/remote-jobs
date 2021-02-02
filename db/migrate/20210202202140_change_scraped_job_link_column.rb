class ChangeScrapedJobLinkColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :scraped_jobs, :link, :job_link
  end
end
