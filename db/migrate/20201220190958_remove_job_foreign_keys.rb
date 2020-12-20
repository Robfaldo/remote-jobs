class RemoveJobForeignKeys < ActiveRecord::Migration[6.0]
  def change
    remove_column(:jobs, :company_id)
    remove_column(:jobs, :stack_id)
    remove_column(:jobs, :level_id)
  end
end
