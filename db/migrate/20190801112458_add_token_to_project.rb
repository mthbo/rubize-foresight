class AddTokenToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :token, :string
  end
end
