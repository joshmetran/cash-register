require 'rails_helper'

RSpec.describe OrderService, type: :service do
  let!(:product1) { Product.create!(code: 'GR1', name: 'Green Tea', price: 3.11, is_buy_one_take_one: true, can_bulk_purchase: false, min_bulk_purchase: 0, bulk_purchase_price: 0) }
  let!(:product2) { Product.create!(code: 'SR1', name: 'Strawberries', price: 5.00, is_buy_one_take_one: false, can_bulk_purchase: true, min_bulk_purchase: 3, bulk_purchase_price: 4.50) }
  let!(:product3) { Product.create!(code: 'CF1', name: 'Coffee', price: 11.23, is_buy_one_take_one: false, can_bulk_purchase: true, min_bulk_purchase: 3, bulk_purchase_price: 7.49) }

  context "order creation" do
    it "creates an order with order details and total amount" do
      order_params = {
        order_details_attributes: [
          { product_id: product1.id, qty: 1 },
          { product_id: product2.id, qty: 1 }
        ]
      }

      order_service = OrderService.new(order_params)
      result = order_service.execute
      total_amount = order_service.order.order_details.sum { |item| item[:total_price] }

      expect(result).to be true
      expect(order_service.order).to be_persisted
      expect(order_service.order.total_price).to eq(total_amount)
    end

    it "creates an order with buy one take one product" do
      order_params = {
        order_details_attributes: [
          { product_id: product1.id, qty: 1 }
        ]
      }

      order_service = OrderService.new(order_params)
      result = order_service.execute
      buy_one_take_one_product = order_service.order.order_details.first
      product_total_amount = product1.price * buy_one_take_one_product.qty
      actual_qty = buy_one_take_one_product.qty * 2

      expect(result).to be true
      expect(order_service.order).to be_persisted
      expect(buy_one_take_one_product.actual_qty).to eq(actual_qty)
      expect(buy_one_take_one_product.total_price).to eq(product_total_amount)
    end

    it "creates an order with price discount for bulk purchases" do
      order_params = {
        order_details_attributes: [
          { product_id: product2.id, qty: 3 }
        ]
      }

      order_service = OrderService.new(order_params)
      result = order_service.execute
      product = order_service.order.order_details.first
      product_total_amount = product2.bulk_purchase_price * product.qty
      
      expect(result).to be true
      expect(order_service.order).to be_persisted
      expect(product.qty).to be >= 3
      expect(product.total_price).to eq(product_total_amount)
    end
  end

  context "no order details" do
    it "fails if no order details are given" do
      order_params = {
        order_details_attributes: []
      }

      order_service = OrderService.new(order_params)
      result = order_service.execute

      expect(result).to be false
      expect(order_service.errors).to include("Order must have at least one order detail")
    end
  end

  context "missing product" do
    it "fails if a product doesn't exist" do
      order_params = {
        order_details_attributes: [
          { product_id: 4, qty: 1 }
        ]
      }

      order_service = OrderService.new(order_params)
      result = order_service.execute
      product_id = order_params[:order_details_attributes][0][:product_id]

      expect(result).to be false
      expect(order_service.errors).to include("Product with ID #{product_id} not found")
    end
  end

  context "invalid quantity" do
    it "fails if quantity is less than one" do
      order_params = {
        order_details_attributes: [
          { product_id: product2.id, qty: 0 }
        ]
      }

      order_service = OrderService.new(order_params)
      result = order_service.execute

      expect(result).to be false
      expect(order_service.errors).to include("Quantity must be greater than 0")
    end
  end
end