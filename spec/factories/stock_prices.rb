FactoryBot.define do
  factory :stock_price do
    amount { "9.99" }
    percent_change { "9.99" }
    volume { 1 }
    currency { "MyString" }
    association :stock
  end
end
