class AddFieldsToJobTechnology < ActiveRecord::Migration[6.0]
  def change
    add_column(:job_technologies, :title_matches, :integer)
    add_column(:job_technologies, :description_matches, :integer)
  end
end
