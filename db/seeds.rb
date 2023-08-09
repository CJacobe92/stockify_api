# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Administrator.create({
  firstname:'admin',
  lastname: 'user',
  email: 'admin@email.com',
  password: 'admin',
  password_confirmation: 'admin'
})

User.create({
  firstname:'test',
  lastname: 'user',
  email: 'test.user@email.com',
  password: 'password',
  password_confirmation: 'password',
  activated: true
})