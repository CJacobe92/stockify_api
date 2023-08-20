FactoryBot.define do
  factory :stock_price do
    name {"My Corporation"}
    symbol {"MC"}
    price { "0.45" }
    percent_change { "-0.025" }
    volume { "1500" }
    currency { "PHP" }
    association :stock
  end
end
