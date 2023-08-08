class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :password_digest
      t.boolean :activated
      t.string :token
      t.string :reset_token
      t.string :activation_token
      t.string :secret_key

      t.timestamps
    end
  end
end
