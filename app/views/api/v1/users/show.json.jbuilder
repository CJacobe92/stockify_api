json.data do
  json.extract! @current_user, :id, :firstname, :lastname, :email, :created_at, :updated_at
    json.accounts @current_user.accounts do |account|
      json.extract! account, :id, :name, :balance, :created_at, :updated_at
        json.portfolios account.portfolios do |portfolio|
          json.extract! portfolio, :id, :shares, :purchase_price, :unrealized_pl, :equity, :stock_id, :created_at, :updated_at
        end
    end
end
