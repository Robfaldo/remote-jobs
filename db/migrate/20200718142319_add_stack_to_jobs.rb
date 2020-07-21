class AddStackToJobs < ActiveRecord::Migration[6.0]
  def change
    add_reference :jobs, :stack
  end
end
