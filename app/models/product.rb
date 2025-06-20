class Product < ApplicationRecord
  has_many :order_details
  has_many :orders, through: :order_details  

  validates :code, :name, :price, presence: true

  validates :price,
    numericality: { :only_integer => false },
    if: :price?

  validates :min_bulk_purchase,
    numericality: { :only_integer => true, greater_than: 0 },
    if: :can_bulk_purchase?
  
  validates :bulk_purchase_price,
    numericality: { :only_integer => false, greater_than: 0 },
    if: :can_bulk_purchase?
end