class OrderService
  attr_reader :order, :errors

  def initialize(order_params)
    @order_details_params = order_params[:order_details_attributes] || []
    @errors = []
  end

  def find_item(items, item_id)
    items.find { |obj| obj.id == item_id }
  end

  def execute
    ActiveRecord::Base.transaction do
      @order = Order.create!(invoice_no: DateTime.now.to_i)      

      product_ids = @order_details_params.map { |d| d[:product_id] }.uniq
      products = Product.select('id, name, price, is_buy_one_take_one, can_bulk_purchase, min_bulk_purchase, bulk_purchase_price')
        .where(id: product_ids)

      total_amount = 0

      for order_detail in @order_details_params
        product = find_item(products, order_detail[:product_id])
        qty = order_detail[:qty].to_i

        raise ActiveRecord::RecordInvalid.new(@order), "Product with ID #{order_detail[:product_id]} not found" unless product                
        raise ActiveRecord::RecordInvalid.new(@order), 'Quantity must be greater than 0' if qty <= 0

        product_name = product.name
        price = product.price_for(qty)
        total_price = qty * price
        
        remarks = "#{product_name} has bulk purchased discount" if product.has_bulk_purchased_discount?(qty)
        actual_qty = qty
        if product.is_buy_one_take_one
          remarks = "#{product_name} is buy one take one"
          actual_qty = qty * 2
        end

        @order.order_details.build(
          product: product,
          qty: qty,
          actual_qty: actual_qty,
          price: price,
          total_price: total_price,
          remarks: remarks
        )

        total_amount += total_price
      end

      raise ActiveRecord::RecordInvalid.new(@order), "Order must have at least one order detail" if @order.order_details.empty?

      @order.total_price = total_amount
      @order.save!
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    @errors << e.message
    false
  end
end