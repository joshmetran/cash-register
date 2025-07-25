class ProductSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :price, :is_buy_one_take_one,
    :can_bulk_purchase, :min_bulk_purchase, :bulk_purchase_price,
    :img_url, :created_at, :updated_at
end
