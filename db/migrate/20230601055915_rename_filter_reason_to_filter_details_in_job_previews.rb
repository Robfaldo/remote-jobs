class RenameFilterReasonToFilterDetailsInJobPreviews < ActiveRecord::Migration[7.0]
  def change
    rename_column :job_previews, :filter_reason, :filter_details
  end
end
