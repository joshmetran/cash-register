class Api::OrdersController < ApplicationController
  def create
    order_service = OrderService.new(order_params)

    if order_service.execute
      render json: order_service.order, include: :order_details, status: :created
    else
      render json: { errors: order_service.errors }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(order_details_attributes: [:product_id, :qty])
  end
end
