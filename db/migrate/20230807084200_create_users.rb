class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :password_digest
      t.boolean :activated, default: -> { false }
      t.string :token
      t.string :reset_token
      t.string :activation_token
      t.string :otp_secret_key
      t.boolean :otp_required, default: -> { true }
      t.boolean :otp_enabled, default: -> { false }

      t.timestamps
    end
  end
end
