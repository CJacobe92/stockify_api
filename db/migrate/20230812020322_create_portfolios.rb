class CreatePortfolios < ActiveRecord::Migration[7.0]
  def change
    create_table :portfolios do |t|
      t.string :symbol
      t.string :description
      t.decimal :current_price
      t.decimal :percent_change
      t.decimal :average_purchase_price
      t.integer :total_quantity
      t.decimal :total_value 
      t.decimal :total_gl
      t.decimal :total_cash_value
      t.references :account, null: false, foreign_key: true
      t.references :stock, null: true, foreign_key: true

      t.timestamps
    end
  end
end
