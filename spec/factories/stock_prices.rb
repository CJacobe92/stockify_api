FactoryBot.define do
  factory :stock_price do
    sequence(:id) { |n| n }
    name {"My Corporation"}
    symbol {"MC"}
    price { "0.45" }
    percent_change { "-0.025" }
    volume { "1500" }
    currency { "PHP" }
    association :stock

    after(:build) do |stock_price|
      stock_price.stock ||= FactoryBot.create(:stock)
    end
  end
end
