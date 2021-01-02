class AddReviewedToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :reviewed, :boolean, :default => false
  end
end
