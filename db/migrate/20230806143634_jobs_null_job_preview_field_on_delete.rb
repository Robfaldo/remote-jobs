class JobsNullJobPreviewFieldOnDelete < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :jobs, :job_previews
    add_foreign_key :jobs, :job_previews, on_delete: :nullify
  end
end
