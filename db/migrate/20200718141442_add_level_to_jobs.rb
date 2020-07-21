class AddLevelToJobs < ActiveRecord::Migration[6.0]
  def change
    add_reference :jobs, :level
  end
end
