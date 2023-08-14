# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Admin.create({
  firstname:'admin',
  lastname: 'user',
  email: 'admin@email.com',
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
    amount: stock_data['price']['amount'],
    percent_change: stock_data['percent_change'],
    volume: stock_data['volume'],
    currency: stock_data['price']['currency']
  )
end