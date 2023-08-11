FactoryBot.define do
  factory :admin do
    sequence(:firstname) { |n| "test#{n}"}
    sequence(:lastname) { |n| "admin#{n}"}
    sequence(:email) { |n| "test#{n}.admin#{n}@email.com"}
    password {'password'}
    password_confirmation {'password'}
  end

  factory :incorrect_admin, class: 'Admin' do
    sequence(:firstname) {" "}
    sequence(:lastname) {" "}
    sequence(:email) { "not_a_valid_email"}
    password {'not_a_valid_password'}
    password_confirmation {'not_a_valid_password_confirmation'}
  end
end