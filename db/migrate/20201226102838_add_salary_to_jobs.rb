class AddSalaryToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :salary, :string
  end
end
