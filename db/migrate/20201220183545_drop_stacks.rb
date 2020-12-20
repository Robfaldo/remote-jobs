class DropStacks < ActiveRecord::Migration[6.0]
  def change
    drop_table :stacks
  end
end
