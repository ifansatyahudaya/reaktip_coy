class ProductsController < ApplicationController
  before_action :set_product, only: [:update, :destroy]

  def index
    @products = Product.all
    @measurement_options = Product::MEASUREMENT # ieu naon
  end

  def create
    product = Product.new(product_params)

    if product.save
      render json: product.as_json
    else
      render json: { errors: product.errors.full_messages.to_json, status: :unprocessable_entity }
    end
  end

  def update
    if @product.update(product_params)
      render json: @product.as_json
    else
      render json: { errors: @product.errors.full_messages, status: :unprocessable_entity  }
    end
  end

  def destroy
    if @product.destroy
      render json: @product.as_json
    else
      render json: { errors: @product.errors.full_messages }
    end
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :price, :quantity, :measurement, :description)
    end
end
