class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.integer :quantity 
      t.decimal :price
      t.string :symbol
      t.decimal :total_purchase
      t.references :account, null: false, foreign_key: true
      t.references :stock, null: true, foreign_key: true

      t.timestamps
    end
  end
end
