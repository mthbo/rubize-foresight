class ChangeIssuedAtOfSource < ActiveRecord::Migration[5.2]
  def change
    change_column :sources, :issued_at, :datetime
  end
end
