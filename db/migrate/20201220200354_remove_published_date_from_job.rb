class RemovePublishedDateFromJob < ActiveRecord::Migration[6.0]
  def change
    remove_column :jobs, :published_date
  end
end
