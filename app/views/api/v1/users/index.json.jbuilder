# frozen_string_literal: true
json.data do
  json.array! @users do |user|
    json.extract! user, :id, :firstname, :lastname, :email, :created_at, :updated_at
  end
end