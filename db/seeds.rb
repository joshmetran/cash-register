# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


Product.create([
  { code: 'GR1', name: 'Green Tea', price: 3.11, is_buy_one_take_one: true, can_bulk_purchase: false, min_bulk_purchase: 0, bulk_purchase_price: 0 },
  { code: 'SR1', name: 'Strawberries', price: 5.00, is_buy_one_take_one: false, can_bulk_purchase: true, min_bulk_purchase: 3, bulk_purchase_price: 4.50 },
  { code: 'CF1', name: 'Coffee', price: 11.23, is_buy_one_take_one: false, can_bulk_purchase: true, min_bulk_purchase: 3, bulk_purchase_price: 7.49 }
])