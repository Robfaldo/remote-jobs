class AddRequirementsToJob < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :requires_experience, :string, default: false
    add_column :jobs, :requires_stem_degree, :string, default: false
  end
end
