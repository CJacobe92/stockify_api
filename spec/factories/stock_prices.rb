FactoryBot.define do
  factory :stock_price do
    name {"My Corporation"}
    symbol {"MC"}
    amount { "0.455" }
    percent_change { "-0.025" }
    volume { "100000" }
    currency { "PHP" }
    association :stock
  end
end
