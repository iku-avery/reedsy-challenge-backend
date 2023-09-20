require 'rails_helper'

RSpec.describe UpdateProductService do
  let(:service) { described_class.new }

  describe '#call' do
    let(:product) { FactoryBot.create(:product) }
    let(:product_id) { product.id }
    let(:product_attributes) { { price: 9.99 } }

    context 'product exists and attributes are valid' do
      it 'returns a 200 response with the updated product' do
        result = service.call(product_id, product_attributes)
        expect(result.code).to eq(200)
        expect(result.body).to be_a(Product)
        expect(result.body.price).to eq(9.99)
      end
    end

    context 'product exists and attributes are not valid' do
        it 'returns a 400 response with the updated product' do
          not_a_positive_number = { price: -1 }
          empty_params = {}
          invalid_params = { not_a_price: 'not a price' }
          [not_a_positive_number, empty_params, invalid_params].each do |invalid_param|
            result = service.call(product_id, invalid_param)
            expect(result.code).to eq(400)
            expect(result.body).to include(error: 'Price must be a positive number')
          end
        end
      end

    context 'product not found' do
      it 'returns a 404 response with an error message' do
        result = service.call('non_existent_id', product_attributes)
        expect(result.code).to eq(404)
        expect(result.body).to include(error: 'Product not found')
      end
    end
  end
end
