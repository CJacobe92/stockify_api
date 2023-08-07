FactoryBot.define do
  factory :user do
    sequence(:firstname) { |n| "John#{n}"}
    sequence(:lastname) { |n| "Wick#{n}"}
    sequence(:email) { |n| "john#{n}.wick#{n}@email.com"}
    password {'password'}
    password_confirmation {'password'}
  end

  factory :incorrect_user, class: 'User' do
    sequence(:firstname) {" "}
    sequence(:lastname) {" "}
    sequence(:email) { "not_a_valid_email"}
    password {'not_a_valid_password'}
    password_confirmation {'not_a_valid_password_confirmation'}
  end
end

