class RemoveActiveFromJob < ActiveRecord::Migration[6.0]
  def change
    remove_column :jobs, :active
  end
end
