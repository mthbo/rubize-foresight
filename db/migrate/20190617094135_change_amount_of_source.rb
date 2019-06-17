class ChangeAmountOfSource < ActiveRecord::Migration[5.2]
  def change
    rename_column :sources, :amount_cents, :price_cents
  end
end
