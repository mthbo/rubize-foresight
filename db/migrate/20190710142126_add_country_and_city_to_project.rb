class AddCountryAndCityToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :country_code, :string
    add_column :projects, :city, :string
  end
end
