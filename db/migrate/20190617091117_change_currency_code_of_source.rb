class ChangeCurrencyCodeOfSource < ActiveRecord::Migration[5.2]
  def change
    rename_column :sources, :currency_code, :currency
  end
end
