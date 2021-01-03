class ChangeJobsRequiresColumnsToBoolean < ActiveRecord::Migration[6.0]
  def change
    remove_column :jobs, :requires_stem_degree
    remove_column :jobs, :requires_experience

    add_column :jobs, :requires_stem_degree, :boolean, default: false
    add_column :jobs, :requires_experience, :boolean, default: false
  end
end
