class OrderDetailSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :product_img_url, :qty, :actual_qty, :price, :total_price, :remarks

  belongs_to :product
  belongs_to :order

  def product_name
    object.product.name
  end

  def product_img_url
    object.product.img_url
  end
end
