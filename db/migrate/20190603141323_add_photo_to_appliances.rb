class AddPhotoToAppliances < ActiveRecord::Migration[5.2]
  def change
    add_column :appliances, :photo, :string
  end
end
