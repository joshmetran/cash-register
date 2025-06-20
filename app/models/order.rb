class Order < ApplicationRecord
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  validates :total_price, presence: true

  validates :total_price,
    numericality: { :only_integer => false },
    if: :total_price?

  validate :must_have_order_detail

  def must_have_order_detail
    if order_details.empty? || order_details.all?(&:marked_for_destruction?)
      errors.add(:base, "Order must have at least one order detail")
    end
  end
end
