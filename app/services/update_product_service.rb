class UpdateProductService
    include ResultHandler
  
    def call(product_id, product_attributes)
      product = Product.find_by(id: product_id)

      return not_found_result('Product not found') unless product
      return invalid_request_result('Price must be a positive number') unless valid_price?(product_attributes[:price])
      return invalid_request_result(product.errors.full_messages) unless product.update(product_attributes)

      ok_result(product)
    end

    private

    def valid_price?(price)
      return false unless price.is_a?(Numeric) && price >= 0
      true
    end
end