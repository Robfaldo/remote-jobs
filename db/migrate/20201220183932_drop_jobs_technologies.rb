class DropJobsTechnologies < ActiveRecord::Migration[6.0]
  def change
    drop_table :jobs_technologies
  end
end
