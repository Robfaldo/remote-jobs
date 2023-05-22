class DropAdminsComments < ActiveRecord::Migration[7.0]
  def change
    drop_table :active_admin_comments
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
