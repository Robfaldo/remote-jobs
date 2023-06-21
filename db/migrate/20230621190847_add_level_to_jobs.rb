class AddLevelToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :level, :integer
  end
end
