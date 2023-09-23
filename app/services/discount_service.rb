class DiscountService
    TSHIRT_CODE = 'TSHIRT'.freeze
    MUG_CODE = 'MUG'.freeze
  
    DISCOUNT_RULES = {
      TSHIRT_CODE => {
        discount_percentage: 30,
        minimum_quantity_for_discount: 3
      },
      MUG_CODE => {
        increment_percentage: 2,
        max_items_for_incremental_discount: 150,
        fixed_discount_percentage: 30,
        minimum_quantity_for_discount: 10
      }
    }.freeze
  
    def initialize(product, cart_item)
      @product = product
      @cart_item = cart_item
      @quantity = cart_item[:quantity]
    end
  
    def apply
      return calculate_original_price unless eligible_for_discount?
  
      product_discount_rules = DISCOUNT_RULES[@product.code]
  
      case @product.code
      when TSHIRT_CODE
        apply_discount(product_discount_rules[:discount_percentage])
      when MUG_CODE
        apply_mug_discount(product_discount_rules)
      else
        calculate_original_price
      end
    end
  
    private
  
    def eligible_for_discount?
        product_discount_rules = DISCOUNT_RULES[@product.code]
        return false unless product_discount_rules
  
        @quantity >= product_discount_rules[:minimum_quantity_for_discount]
    end
  
    def apply_mug_discount(product_discount_rules)
      if @quantity >= 10 && @quantity <= product_discount_rules[:max_items_for_incremental_discount]
        discount_percentage = (@quantity / 10) * product_discount_rules[:increment_percentage]
      elsif @quantity >= product_discount_rules[:max_items_for_incremental_discount]
        discount_percentage = product_discount_rules[:fixed_discount_percentage]
      end
  
      apply_discount(discount_percentage)
    end
  
    def apply_discount(discount_percentage)
      discount_percentage = BigDecimal(discount_percentage) / BigDecimal(100)
      discounted_price = BigDecimal(@product.price) * (BigDecimal('1') - discount_percentage)
      discounted_price * BigDecimal(@quantity)
    end
  
    def calculate_original_price
      BigDecimal(@product.price) * BigDecimal(@quantity)
    end
end
  