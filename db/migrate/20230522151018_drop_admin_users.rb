class DropAdminUsers < ActiveRecord::Migration[7.0]
  def change
    drop_table :admin_users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
