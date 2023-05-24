class RemoveSearchedLocationFromJobs < ActiveRecord::Migration[7.0]
  def change
    remove_column :jobs, :searched_location, :string
  end
end
