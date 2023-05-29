class RemoveReviewedFromJob < ActiveRecord::Migration[7.0]
  def change
    remove_column :jobs, :reviewed, :boolean
  end
end
