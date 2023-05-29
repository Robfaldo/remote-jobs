class RemoveUnusedJobAttributes < ActiveRecord::Migration[7.0]
  def change
    remove_column :jobs, :salary, :string
    remove_column :jobs, :requires_stem_degree, :boolean
    remove_column :jobs, :requires_experience, :boolean
    remove_column :jobs, :edited, :boolean
  end
end
