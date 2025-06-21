class OrderDetailSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :qty, :actual_qty, :price, :total_price, :remarks

  belongs_to :product
  belongs_to :order

  def product_name
    object.product.name
  end
end
