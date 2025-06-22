class Api::ProductsController < ApplicationController
  before_action :find_product, only: [:show, :update, :destroy]

  def index
    products = Product.sortBy(
      params[:sort_by_key] || 'id',
      params[:sort_by_order] || 'ASC'
    )

    products = products.search(params[:search]) unless params[:search].nil?

    @pagy, @products = pagy(products, **paginate_options)
    render :index, locals: { products: @products, pagy: @pagy }, status: :ok
  rescue Pagy::OverflowError
    render json: { error: "Page number out of bounds" }, status: :bad_request
  end

  def show
    if stale?(last_modified: @product.updated_at)
      render json: @product
    end
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created
    else
      raise ActiveRecord::RecordInvalid.new(@product)
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      raise ActiveRecord::RecordInvalid.new(@product)
    end
  end

  def destroy
    @product.destroy
    render json: { success: true }  
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end

  def product_params
    params
      .require(:product)
      .permit(:code, :name, :price, :is_buy_one_take_one, :can_bulk_purchase, :min_bulk_purchase, :bulk_purchase_price)
  end
end
