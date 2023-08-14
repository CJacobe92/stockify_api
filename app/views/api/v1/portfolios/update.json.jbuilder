json.message 'User updated'
json.data do
  json.extract! @current_portfolio, :id, :shares, :unrealized_pl, :equity, :created_at, :updated_at
end