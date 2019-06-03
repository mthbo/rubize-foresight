class AddUserIdToAppliances < ActiveRecord::Migration[5.2]
  def change
    add_reference :appliances, :user, foreign_key: true
  end
end
