class Account < ApplicationRecord
  has_one :portfolio, dependent: :destroy
  belongs_to :user
end
