class AddEditedToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :edited, :boolean, default: false
  end
end
