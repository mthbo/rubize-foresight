class AddCurrentTypeToAppliance < ActiveRecord::Migration[5.2]
  def change
    add_column :appliances, :current_type, :integer
  end
end
