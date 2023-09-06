class User < ApplicationRecord
    after_create :generate_account_number

    # associations
    has_secure_password
    has_many :accounts, dependent: :destroy

    # validations

    validates :firstname, presence: true, on: :create
    validates :lastname, presence: true, on: :create
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create
    validates :password, presence: true, on: :create
    validates :password_confirmation, presence: true, on: :create

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
