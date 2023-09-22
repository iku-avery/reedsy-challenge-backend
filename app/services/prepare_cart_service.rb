require 'bigdecimal'

class PrepareCartService
  include ResultHandler

  def call(cart_items)
    product_ids = cart_items.map { |cart_item| cart_item[:product_id] }
    products = fetch_products(product_ids)

    return invalid_request_result('Quantity must be a positive number') unless valid_cart_items?(cart_items)
    return not_found_result('Product not found') if products.empty?

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
      total_price: "%.2f" % total_price.truncate(2)
    }
  end

  def calculate_total_price(cart_items, products)
    total_price = BigDecimal('0.0')

    cart_items.each do |cart_item|
      product = products[cart_item[:product_id]]
      item_price = DiscountService.new(product, cart_item).apply
      total_price += item_price
    end

    [total_price, products.values]
  end

  def serialize_product(product, cart_items)
    {
      id: product.id,
      code: product.code,
      name: product.name,
      price: "%.2f" % product.price.truncate(2),
      quantity: cart_items.find { |item| item[:product_id] == product.id }[:quantity]
    }
  end
end
