class CreateTechnologies < ActiveRecord::Migration[6.0]
  def change
    create_table :technologies do |t|
      t.string :name
      t.text :aliases
      t.boolean :is_language
      t.boolean :is_framework
      t.boolean :used_for_frontend
      t.boolean :used_for_backend

      t.timestamps
    end
  end
end
