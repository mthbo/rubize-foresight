class RemoveFieldsOfProject < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :address
    remove_column :projects, :latitude
    remove_column :projects, :longitude
    remove_column :projects, :user_id
  end
end
