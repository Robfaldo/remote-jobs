class AddFieldsToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column(:jobs, :description, :text)
    add_column(:jobs, :source, :string)
    add_column(:jobs, :job_board, :string)
  end
end
