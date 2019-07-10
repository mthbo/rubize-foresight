class ChangeCurrentTypeOfProject < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :current_type

    add_column :projects, :current_ac, :boolean
    add_column :projects, :current_dc, :boolean
  end
end
