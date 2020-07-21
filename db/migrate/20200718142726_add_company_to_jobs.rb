class AddCompanyToJobs < ActiveRecord::Migration[6.0]
  def change
    add_reference :jobs, :company
  end
end
