class RenameStatusReasonInJobPreviews < ActiveRecord::Migration[7.0]
  def change
    rename_column :job_previews, :status_reason, :filter_reason
  end
end
