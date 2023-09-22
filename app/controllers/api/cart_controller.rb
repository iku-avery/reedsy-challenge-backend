class Api::CartController < ApplicationController
    def checkout
      params[:products].blank? && (render json: { error: 'Invalid request parameters' }, status: :bad_request) && return

      result = PrepareCartService.new.call(cart_params)
      render json: result.body, status: result.code
    end

    private

    def cart_params
        params.require(:products).map do |product_params|
          product_params.permit(:product_id, :quantity)
        end
    end
end
  