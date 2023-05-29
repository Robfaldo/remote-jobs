class RemoveFilteredFromJobPreview < ActiveRecord::Migration[7.0]
  def change
    remove_column :job_previews, :filtered, :boolean
  end
end
