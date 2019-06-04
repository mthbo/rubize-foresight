class AddUseIdToAppliances < ActiveRecord::Migration[5.2]
  def change
    add_reference :appliances, :use, foreign_key: true
  end
end
