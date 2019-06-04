class ChangeTypeOfAppliance < ActiveRecord::Migration[5.2]
  def change
    change_column :appliances, :current_type, :string
  end
end
