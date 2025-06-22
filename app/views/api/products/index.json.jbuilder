json.products @products do |product|
  json.id product.id
  json.code product.code
  json.name product.name
  json.img_url product.img_url
  json.price product.price
  json.is_buy_one_take_one product.is_buy_one_take_one
  json.can_bulk_purchase product.can_bulk_purchase
  json.min_bulk_purchase product.min_bulk_purchase
  json.bulk_purchase_price product.bulk_purchase_price
  json.created_at product.created_at
  json.updated_at product.updated_at
end

json.pagination do
  json.page @pagy.page
  json.per_page @pagy.limit
  json.count @pagy.count

  json.next @pagy.next ? @pagy.next : 0
  json.prev @pagy.prev ? @pagy.prev : 0
end

