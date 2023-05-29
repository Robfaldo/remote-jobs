class AddFilteredToJob < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :filtered, :boolean, default: false
  end
end
