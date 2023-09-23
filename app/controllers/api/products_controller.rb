class Api::ProductsController < ApplicationController
    def index
        @products = Product.all
        render json: @products, status: :ok
    end

    def update
        params[:product].blank? && (render json: { error: 'Invalid request parameters' }, status: :bad_request) && return

        result = ::UpdateProductService.new.call(params[:id], product_params)
        render json: result.body, status: result.code
    end      

    private

    def product_params
        params.require(:product).permit(:price)
    end
end
