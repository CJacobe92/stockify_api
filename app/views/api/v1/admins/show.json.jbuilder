json.data do
  json.extract! @current_admin, :id, :firstname, :lastname, :email, :created_at, :updated_at
end