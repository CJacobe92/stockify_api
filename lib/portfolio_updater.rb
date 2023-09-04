module PortfolioUpdater

  def recalculate_global_values(existing_portfolio)
    
    sp = StockPrice.find(existing_portfolio.stock_id)
    current_price = sp&.price

    # Calculate total_gl and percent_change
    total_gl = calculate_total_gl(sp.price, existing_portfolio.average_purchase_price, existing_portfolio.total_quantity)
    percent_change = calculate_percent_change(total_gl, existing_portfolio.total_value)
    total_value = current_price * existing_portfolio.total_quantity

    # Update the calculated fields
    existing_portfolio.update(
      current_price: current_price,
      total_gl: total_gl, 
      percent_change: percent_change,
      total_value: total_value
    ) if existing_portfolio.present?
  end

  def calculate_avg_purchase_price(total_value, total_quantity)
    if total_quantity != 0
      average_purchase_price = total_value / total_quantity
    else
      average_purchase_price = 0
    end
  end

  def calculate_percent_change(total_gl, total_value)
    if total_gl !=0.0
      percent_change = ( total_gl / total_value) * 100
    else
      percent_change = 0
    end
  end

  def calculate_total_gl(current_price, average_purchase_price, total_quantity)
    if average_purchase_price !=0
      total_gl = (current_price - average_purchase_price) * total_quantity
    else
      total_gl = 0
    end
  end
end