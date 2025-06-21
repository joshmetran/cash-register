class OrderSerializer < ActiveModel::Serializer
  attributes :id, :invoice_no, :total_price, :created_at, :updated_at
  has_many :products
  has_many :order_details
end
