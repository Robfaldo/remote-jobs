class RenameScrapedJobsToJobPreviews < ActiveRecord::Migration[7.0]
  def change
    rename_table :scraped_jobs, :job_previews
  end
end
