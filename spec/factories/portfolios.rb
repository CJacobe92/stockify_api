FactoryBot.define do
  factory :portfolio do
    shares { 1 }
    unrealized_pl { "9.99" }
    equity { "9.99" }
    association :account
    association :stock
  end
end
