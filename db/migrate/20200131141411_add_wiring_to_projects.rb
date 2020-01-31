class AddWiringToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :wiring, :boolean
  end
end
