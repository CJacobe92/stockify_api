FactoryBot.define do
  factory :sell, class: 'Transaction' do
    transaction_type { "sell" }
    quantity { "500" }
    association :stock
    association :account
  end

  factory :buy, class: 'Transaction' do
    transaction_type { "buy" }
    quantity { "500"}
    association :stock
    association :account
  end
end
