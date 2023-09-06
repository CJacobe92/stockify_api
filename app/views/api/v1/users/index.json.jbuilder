json.data do
  json.array! @users do |user|
    json.extract! user, 
      :id, 
      :firstname, 
      :lastname, 
      :email,
      :activated,
      :otp_required,
      :otp_enabled, 
      :created_at, 
      :updated_at
      json.accounts user.accounts do |account|
        json.extract! account, 
          :id, 
          :name,
          :account_number,
          :balance, 
          :created_at, 
          :updated_at
          if account.portfolios.present? 
            json.portfolios account.portfolios do |portfolio|
              json.extract! portfolio,
                :id, 
                :symbol, 
                :description, 
                :current_price, 
                :percent_change, 
                :total_quantity,
                :average_purchase_price, 
                :total_value,
                :total_cash_value,
                :total_gl, 
                :stock_id, 
                :account_id,
                :created_at, 
                :updated_at
            end
          end
          if account.transactions.present?
            json.transactions account.transactions do | transaction |
              json.extract! transaction,
                :id, 
                :transaction_type, 
                :quantity, 
                :price, 
                :symbol,
                :total_cash_value,
                :account_number,
                :stock_id, 
                :account_id, 
                :created_at, 
                :updated_at
            end
          end
      end
  end
end
