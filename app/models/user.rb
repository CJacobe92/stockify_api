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
       accounts.build({name: 'starter', balance: 1000})
    end
end
