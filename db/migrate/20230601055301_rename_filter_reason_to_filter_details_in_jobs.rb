class RenameFilterReasonToFilterDetailsInJobs < ActiveRecord::Migration[7.0]
  def change
    rename_column :jobs, :filter_reason, :filter_details
  end
end
