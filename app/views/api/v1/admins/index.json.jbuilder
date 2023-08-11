# frozen_string_literal: true
json.data do
  json.array! @admins do |admin|
    json.extract! admin, :id, :firstname, :lastname, :email, :created_at, :updated_at
  end
end