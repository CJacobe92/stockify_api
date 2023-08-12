FactoryBot.define do
  factory :transaction do
    type { "" }
    shares { 1 }
    amount { "9.99" }
    association :stock
    association :user
  end
end
