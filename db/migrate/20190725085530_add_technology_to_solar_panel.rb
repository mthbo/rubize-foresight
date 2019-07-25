class AddTechnologyToSolarPanel < ActiveRecord::Migration[5.2]
  def change
    add_column :solar_panels, :technology, :string
  end
end
