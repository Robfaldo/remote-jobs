class RemoveSourceFromJobs < ActiveRecord::Migration[6.0]
  def change
    remove_column :jobs, :source
  end
end
