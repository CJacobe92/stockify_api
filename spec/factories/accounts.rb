FactoryBot.define do
  factory :account do
    name { "MyString" }
    balance { "9.99" }
    association :user
  end
end
