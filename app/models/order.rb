class Order < ApplicationRecord
  CODE_PREFIX = 'INV-00000000'

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  accepts_nested_attributes_for :order_details, allow_destroy: true

  validates :total_price, presence: true

  validates :total_price,
    numericality: { :only_integer => false },
    if: :total_price?

  after_create :add_custom_id

  def add_custom_id
    self.invoice_no = generate_code(CODE_PREFIX, id)
    self.save
  end
end
