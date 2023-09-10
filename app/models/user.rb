class User < ApplicationRecord
    after_create :generate_account_number

    # associations
    has_secure_password
    has_many :accounts, dependent: :destroy

    # validations

    validates :firstname, presence: { message: 'Firstname cannot be empty' }, on: :create
    validates :lastname, presence: { message: 'Lastname cannot be empty' }, on: :create
    validates :email, presence: { message: 'Email cannot be empty' }, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create
    validates :password, presence:  { message: 'Password cannot be empty' }, length: { minimum: 8, maximum: 20 }, on: :create
    validates :password_confirmation, presence: { message: 'Password confirmation cannot be empty' }, true, on: :create
    validates_confirmation_of :password, message: "Passwords do not match", if: -> { password.present? }

    def generate_account_number
        min_number = 100_000
        max_number = 999_999
        new_account_number = rand(min_number..max_number)
        
        while Account.exists?(account_number: new_account_number)
            new_account_number = rand(min_number..max_number)
        end
        
        accounts.build(name: 'starter', balance: 1000, account_number: new_account_number)
    end
    
end
