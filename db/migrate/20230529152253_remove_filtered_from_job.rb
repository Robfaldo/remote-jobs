class RemoveFilteredFromJob < ActiveRecord::Migration[7.0]
  def change
    remove_column :jobs, :filtered, :boolean
  end
end
