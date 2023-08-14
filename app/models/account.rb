class Account < ApplicationRecord
  has_many :portfolios, dependent: :destroy
  has_many :transactions, dependent: :destroy
  belongs_to :user
  
end
