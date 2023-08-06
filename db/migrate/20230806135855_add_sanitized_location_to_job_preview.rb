class AddSanitizedLocationToJobPreview < ActiveRecord::Migration[7.0]
  def change
    add_column :job_previews, :sanitized_location, :string
  end
end
