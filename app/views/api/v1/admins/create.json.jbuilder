if @admin&.errors&.any?
  json.error @admin.errors.full_messages.join(' ')
elsif @admin.save
  json.data do
    json.extract! @admin, :id, :firstname, :lastname, :email, :created_at, :updated_at
  end
end