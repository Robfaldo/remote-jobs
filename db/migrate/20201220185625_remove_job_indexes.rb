class RemoveJobIndexes < ActiveRecord::Migration[6.0]
  def change
    remove_index :jobs, :company_id
    remove_index :jobs, :level_id
    remove_index :jobs, :stack_id
  end
end
