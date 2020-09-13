class AddRequiresDegreeToJob < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :degree_required, :boolean, default: false
  end
end
