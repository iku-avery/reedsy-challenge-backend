require 'bigdecimal'

class PrepareCartService
  Result = Struct.new(:code, :body)

  def call(cart_items)
    product_ids = cart_items.map { |cart_item| cart_item[:product_id] }
    products = fetch_products(product_ids)

    return invalid_request_result unless valid_cart_items?(cart_items)
    return not_found_result if products.empty?

    result = prepare_cart_result(cart_items, products)
    ok_result(result)
  end

  private

  def fetch_products(product_ids)
    Product.where(id: product_ids).index_by(&:id)
  end

  def valid_cart_items?(cart_items)
    cart_items.all? { |item| item[:quantity].is_a?(Numeric) && item[:quantity] > 0 }
  end

  def prepare_cart_result(cart_items, products)
    total_price, products = calculate_total_price(cart_items, products)

    products_data = products.map do |product|
      serialize_product(product, cart_items)
    end

    {
      products: products_data,
      total_price: total_price.to_s('F')
    }
  end

  def calculate_total_price(cart_items, products)
    total_price = BigDecimal('0.0')

    cart_items.each do |cart_item|
      product = products[cart_item[:product_id]]
      item_price = BigDecimal(product.price) * BigDecimal(cart_item[:quantity])
      total_price += item_price
    end

    total_price = total_price.round(2)
    [total_price, products.values]
  end

  def serialize_product(product, cart_items)
    {
      id: product.id,
      code: product.code,
      name: product.name,
      price: product.price.to_s('F'),
      quantity: cart_items.find { |item| item[:product_id] == product.id }[:quantity]
    }
  end

  def ok_result(result)
    Result.new(200, result)
  end

  def invalid_request_result
    Result.new(400, { error: 'Quantity must be a positive number' })
  end

  def not_found_result
    Result.new(404, { error: 'Product not found' })
  end
end
