class RenameJobLinkToUrl < ActiveRecord::Migration[7.0]
  def change
    rename_column :job_previews, :job_link, :url
    rename_column :jobs, :job_link, :url
  end
end
