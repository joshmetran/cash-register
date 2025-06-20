class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_id, :order_id, presence: true
  validates :qty, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { :only_integer => false }  

  before_save :compute_total_price

  def compute_total_price
    self.total_price = qty * price
  end
end
