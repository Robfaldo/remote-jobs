class AddRemoteStatusToJob < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :remote_status, :string
  end
end
