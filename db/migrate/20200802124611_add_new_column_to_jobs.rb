class AddNewColumnToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :active, :boolean, null: false, default: true
  end
end
