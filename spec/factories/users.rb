FactoryBot.define do
  factory :user do
    sequence(:firstname) { |n| "John#{n}"}
    sequence(:lastname) { |n| "Wick#{n}"}
    sequence(:email) { |n| "john#{n}.wick#{n}@email.com"}
    password {'password'}
    password_confirmation {'password'}
  end
end
