class Portfolio < ApplicationRecord
  belongs_to :account
  belongs_to :stock
end
