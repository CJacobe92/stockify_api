FactoryBot.define do
  factory :account do
    name { "starter" }
    balance { "1000.0" }
    association :user
  end
end
