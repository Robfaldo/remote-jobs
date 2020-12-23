class AddStatusReasonToJob < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :status_reason, :string
  end
end
