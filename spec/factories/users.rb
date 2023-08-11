FactoryBot.define do
  factory :user do
    sequence(:firstname) { |n| "dummy#{n}"}
    sequence(:lastname) { |n| "user#{n}"}
    sequence(:email) { |n| "dummy#{n}.user#{n}@email.com"}
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

