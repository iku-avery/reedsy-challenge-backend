# spec/services/prepare_cart_service_spec.rb

require 'rails_helper'

RSpec.describe PrepareCartService do
  let(:service) { PrepareCartService.new }
  let!(:products) do
    [
      FactoryBot.create(:product, price: 18.99, code: 'MUG', name: 'Reedsy Mug', id: 'e60b29f9-0e7c-49f3-92e1-a15d82d5430d'),
      FactoryBot.create(:product, price: 25.99, code: 'TSHIRT', name: 'Reedsy T-shirt', id: '93a43f44-431d-487f-b3d6-20cc697461af')
    ]
  end

  describe '#call' do
    context 'when params are valid' do
      let(:cart_items) do
        [
          { product_id: products.first.id, quantity: 2 },
          { product_id: products.last.id, quantity: 3 }
        ]
      end

      expected_result = {
        :products => [
          {
            :code => "MUG",
            :id => "e60b29f9-0e7c-49f3-92e1-a15d82d5430d",
            :name => "Reedsy Mug",
            :price => 18.99,
            :quantity => 2
          },
          {
            :code => "TSHIRT",
            :id => "93a43f44-431d-487f-b3d6-20cc697461af",
            :name => "Reedsy T-shirt",
            :price => 25.99,
            :quantity => 3
          }
        ],
        :total_price => 115.95
      }


      it 'returns 200 with body containing hash with total price and array of products' do
        result = service.call(cart_items)
        expect(result.code).to eq(200)
        expect(result.body.size).to eq(2)
        expect(result.body).to eq(expected_result)
      end
    end

    context 'when cart_items are invalid' do
      let(:cart_items) do
        [
          { product_id: 1, quantity: 'invalid' },
          { product_id: 2, quantity: -1 }
        ]
      end

      it 'returns a bad request code and message' do
        result = service.call(cart_items)
        expect(result.code).to eq(400)
        expect(result.body).to eq({ error: 'Quantity must be a positive number' })
      end
    end

    context 'when products are not found' do
      let(:cart_items) do
        [
          { product_id: 1000, quantity: 2 },
          { product_id: 2000, quantity: 3 }
        ]
      end

      it 'returns a not found code and message' do
        result = service.call(cart_items)
        expect(result.code).to eq(404)
        expect(result.body).to eq({ error: 'Product not found' })
      end
    end
  end
end
