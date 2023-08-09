FactoryBot.define do
  factory :administrator do
    firstname { "MyString" }
    lastname { "MyString" }
    email { "MyString" }
    password_digest { "MyString" }
    token { "MyString" }
    reset_token { "MyString" }
    secret_key { "MyString" }
  end
end
