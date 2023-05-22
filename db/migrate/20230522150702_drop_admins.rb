class DropAdmins < ActiveRecord::Migration[7.0]
  def change
    drop_table :admins
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
