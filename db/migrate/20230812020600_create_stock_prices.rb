class CreateStockPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_prices do |t|
      t.string :name
      t.string :symbol
      t.decimal :amount
      t.decimal :percent_change
      t.integer :volume
      t.string :currency
      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
