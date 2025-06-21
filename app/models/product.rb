class Product < ApplicationRecord
  has_many :order_details
  has_many :orders, through: :order_details  

  validates :code, :name, :price, presence: true
  validates :code, uniqueness: { case_sensitive: false }, if: -> { self.code.present? }
  validates :name, uniqueness: { case_sensitive: false }, if: -> { self.name.present? }

  validates :price,
    numericality: { :only_integer => false },
    if: :price?

  validates :min_bulk_purchase,
    numericality: { :only_integer => true, greater_than: 0 },
    if: :can_bulk_purchase?
  
  validates :bulk_purchase_price,
    numericality: { :only_integer => false, greater_than: 0 },
    if: :can_bulk_purchase?

  scope :search, ->(keyword) {
    where("code ILIKE :keyword OR name ILIKE :keyword", keyword: "%#{keyword}%")
  }

  scope :sortBy, ->(sort_by_key, sort_by_order) {
    order(sort_by_key => sort_by_order)
  }

  def has_bulk_purchased_discount?(qty)
    can_bulk_purchase? && qty >= min_bulk_purchase
  end

  def price_for(qty)
    has_bulk_purchased_discount?(qty) ? bulk_purchase_price : price
  end
end