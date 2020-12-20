class DropTechnologies < ActiveRecord::Migration[6.0]
  def change
    drop_table :technologies
  end
end
