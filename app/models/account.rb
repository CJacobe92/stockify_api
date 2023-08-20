class Account < ApplicationRecord
  has_many :portfolios, dependent: :destroy
  has_many :transactions, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, on: :create
  validates :balance, presence: true, on: :create


  def update_account_balance(account, ending_balance)
    account = Account.find(account.id)
    account.update(balance: ending_balance) if account.present?
  end

  def update_account_balance_for_total_gl(account, total_gl)
    account = Account.find(account.id)
    
    account.update(balance: account.balance += total_gl) if account.present?
  end

end
