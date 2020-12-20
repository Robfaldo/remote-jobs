class RemoveJobDegreeRequired < ActiveRecord::Migration[6.0]
  def change
    remove_column(:jobs, :degree_required, default: false)
  end
end
