class RemoveJobBoardFromJob < ActiveRecord::Migration[7.0]
  def change
    remove_column :jobs, :job_board, :string
  end
end
