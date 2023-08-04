class AddJobPostingSchemaToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :job_posting_schema, :json
  end
end
