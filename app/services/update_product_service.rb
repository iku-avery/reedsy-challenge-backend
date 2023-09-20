class UpdateProductService
    Result = Struct.new(:code, :body)
  
      def call(product_id, product_attributes)
        product = Product.find_by(id: product_id)
  
        return not_found_result unless product
        return bad_request_result('Price must be a positive number') unless valid_price?(product_attributes[:price])
        return bad_request_result(product.errors.full_messages) unless product.update(product_attributes)
  
        ok_result(product)
      end
  
      private

      def valid_price?(price)
        return false unless price.is_a?(Numeric) && price >= 0
        true
      end
  
      def ok_result(product)
        Result.new(200, product)
      end
  
      def not_found_result
        Result.new(404, { error: 'Product not found' })
      end
  
      def bad_request_result(error)
        Result.new(400, { error: error })
      end
end