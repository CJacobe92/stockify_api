# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Admin.create({
  firstname:'global',
  lastname: 'admin',
  email: 'global.admin@email.com',
  password: 'admin',
  password_confirmation: 'admin'
})

user = User.create({
  firstname:'test',
  lastname: 'user',
  email: 'test.user@email.com',
  password: 'password',
  password_confirmation: 'password',
  activated: true
})

if user
  10.times do |n|
    User.create(
      firstname: 'test',
      lastname: "user#{n + 1}",
      email: "test.user#{n + 1}@example.com",
      password: 'password',
      password_confirmation: 'password',
    )
  end
end

api_endpoint = 'http://phisix-api2.appspot.com/stocks.json'
response = RestClient.get(api_endpoint)
data = JSON.parse(response.body)

data['stock'].each do |stock_data|
  stock = Stock.find_or_initialize_by(symbol: stock_data['symbol'])
  stock.name = stock_data['name']
  stock.save
  
  stock_price = StockPrice.find_or_initialize_by(stock_id: stock.id)
  stock_price.update(
    name: stock_data['name'],
    symbol: stock_data['symbol'],
    price: stock_data['price']['amount'],
    percent_change: stock_data['percent_change'],
    volume: stock_data['volume'],
    currency: stock_data['price']['currency']
  )
end