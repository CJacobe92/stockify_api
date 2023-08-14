class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.integer :shares
      t.decimal :amount
      t.decimal :balance
      t.references :stock, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
