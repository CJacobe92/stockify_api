class CreatePortfolios < ActiveRecord::Migration[7.0]
  def change
    create_table :portfolios do |t|
      t.string :symbol
      t.string :description
      t.decimal :current_price, precision: 10, scale: 2
      t.decimal :percent_change, precision: 10, scale: 2
      t.decimal :average_purchase_price, precision: 10, scale: 2
      t.integer :total_quantity
      t.decimal :total_value, precision: 10, scale: 2
      t.decimal :total_gl, precision: 10, scale: 2
      t.decimal :total_cash_value, precision: 10, scale: 2
      t.references :account, null: false, foreign_key: true
      t.references :stock, null: true, foreign_key: true

      t.timestamps
    end
  end
end
