class AddFilterReasonToJobPreviews < ActiveRecord::Migration[7.0]
  def change
    add_column :job_previews, :filter_reason, :integer
  end
end
