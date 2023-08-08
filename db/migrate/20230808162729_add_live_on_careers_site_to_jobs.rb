class AddLiveOnCareersSiteToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :live_on_careers_site, :boolean, null: true
  end
end
