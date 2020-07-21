class CreateJoinTableJobsTechnologies < ActiveRecord::Migration[6.0]
  def change
    create_join_table :jobs, :technologies do |t|
      # t.index [:job_id, :technology_id]
      # t.index [:technology_id, :job_id]
    end
  end
end
