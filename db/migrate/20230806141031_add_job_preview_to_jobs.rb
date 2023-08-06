class AddJobPreviewToJobs < ActiveRecord::Migration[7.0]
  def change
    add_reference :jobs, :job_preview, null: true, foreign_key: true
  end
end
