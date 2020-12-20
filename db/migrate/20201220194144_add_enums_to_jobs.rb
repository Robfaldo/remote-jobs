class AddEnumsToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :status, :integer
    add_column :jobs, :source, :integer
  end
end
