class RenameStatusReasonInJobs < ActiveRecord::Migration[7.0]
  def change
    rename_column :jobs, :status_reason, :filter_reason
  end
end
