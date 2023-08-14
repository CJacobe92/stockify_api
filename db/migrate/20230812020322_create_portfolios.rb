class CreatePortfolios < ActiveRecord::Migration[7.0]
  def change
    create_table :portfolios do |t|
      t.integer :shares
      t.decimal :purchase_price
      t.decimal :unrealized_pl
      t.decimal :equity
      t.references :account, null: false, foreign_key: true
      t.references :stock, null: true, foreign_key: true

      t.timestamps
    end
  end
end
