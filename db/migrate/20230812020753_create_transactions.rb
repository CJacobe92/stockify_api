class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.integer :quantity 
      t.decimal :price, precision: 10, scale: 2
      t.string :symbol
      t.decimal :total_cash_value, precision: 10, scale: 2
      t.references :account, null: false, foreign_key: true
      t.references :stock, null: true, foreign_key: true

      t.timestamps
    end
  end
end
