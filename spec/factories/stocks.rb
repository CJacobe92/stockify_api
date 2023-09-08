FactoryBot.define do
  factory :stock do
    sequence(:id) { |n| n }
    name {"My Corporation"}
    symbol {"MC"}
  end
end
