class Api::OrdersController < ApplicationController
  
  def index
    orders = Order.sortBy(
      params[:sort_by_key] || 'created_at',
      params[:sort_by_order] || 'DESC'
    )

    orders = orders.search(params[:search]) unless params[:search].nil?

    @pagy, @orders = pagy(orders, **paginate_options)
    render :index, locals: { orders: @orders, pagy: @pagy }, status: :ok
  rescue Pagy::OverflowError
    render json: { error: "Page number out of bounds" }, status: :bad_request
  end

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
