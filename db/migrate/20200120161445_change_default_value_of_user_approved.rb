class ChangeDefaultValueOfUserApproved < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :approved, :boolean, default: true
  end
end
