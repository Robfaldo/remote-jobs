class AddFilterReasonToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :filter_reason, :integer
  end
end
