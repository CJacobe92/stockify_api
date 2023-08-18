FactoryBot.define do
  factory :sell, class: 'Transaction' do
    transaction_type { "sell" }
    shares { "500" }
    association :stock
    association :account
  end

  factory :buy, class: 'Transaction' do
    transaction_type { "buy" }
    shares { "500"}
    association :stock
    association :account
  end
end
