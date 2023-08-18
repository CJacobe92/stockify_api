class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.decimal :value
      t.decimal :balance
      t.decimal :percent_change
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
