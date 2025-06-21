json.orders @orders do |order|
  json.id order.id
  json.invoice_no order.invoice_no
  json.total_price order.total_price
  json.created_at order.created_at
  json.updated_at order.updated_at
end

json.pagination do
  json.page @pagy.page
  json.per_page @pagy.limit
  json.count @pagy.count

  json.next @pagy.next ? @pagy.next : 0
  json.prev @pagy.prev ? @pagy.prev : 0
end