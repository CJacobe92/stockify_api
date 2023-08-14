json.data do
  json.array! @users do |user|
    json.extract! user, :id, :firstname, :lastname, :email, :created_at, :updated_at
      json.accounts user.accounts do |account|
        json.extract! account, :id, :name, :balance, :created_at, :updated_at
          if account.portfolios.present?
            json.portfolios do
              json.extract! account.portfolios, :id, :shares, :purchase_price, :unrealized_pl, :equity, :stock_id, :created_at, :updated_at
            end
        end
      end
  end
end
