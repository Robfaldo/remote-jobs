class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.date :published_date
      t.string :title
      t.string :job_link

      t.timestamps
    end
  end
end
