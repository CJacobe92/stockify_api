json.message 'User updated'
json.data do
  json.extract! @current_account, :id, :name, :balance, :created_at, :updated_at
end