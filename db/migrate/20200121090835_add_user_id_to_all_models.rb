class AddUserIdToAllModels < ActiveRecord::Migration[5.2]
  def change
    add_reference :appliances, :user, foreign_key: true
    add_reference :batteries, :user, foreign_key: true
    add_reference :communication_modules, :user, foreign_key: true
    add_reference :distributions, :user, foreign_key: true
    add_reference :power_systems, :user, foreign_key: true
    add_reference :projects, :user, foreign_key: true
    add_reference :solar_panels, :user, foreign_key: true
    add_reference :uses, :user, foreign_key: true
  end
end
