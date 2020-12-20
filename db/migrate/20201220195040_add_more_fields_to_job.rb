class AddMoreFieldsToJob < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :source, :string
    add_column :jobs, :source_id, :string
  end
end
