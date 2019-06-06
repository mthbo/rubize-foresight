class RemoveUserIdFromAppliance < ActiveRecord::Migration[5.2]
  def change
    remove_column :appliances, :user_id
  end
end
