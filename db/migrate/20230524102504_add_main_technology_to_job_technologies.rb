class AddMainTechnologyToJobTechnologies < ActiveRecord::Migration[7.0]
  def change
    add_column :job_technologies, :main_technology, :boolean, default: false
  end
end
