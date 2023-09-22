# spec/services/prepare_cart_service_spec.rb

require 'rails_helper'

RSpec.describe PrepareCartService do
  let(:service) { PrepareCartService.new }
  let!(:products) do
    [
      FactoryBot.create(:product, price: 6.00, code: 'MUG', name: 'Reedsy Mug', id: 'e60b29f9-0e7c-49f3-92e1-a15d82d5430d'),
      FactoryBot.create(:product, price: 15.00, code: 'TSHIRT', name: 'Reedsy T-shirt', id: '93a43f44-431d-487f-b3d6-20cc697461af'),
      FactoryBot.create(:product, price: 20.00, code: 'HOODIE', name: 'Reedsy Hoodie', id: '3181394d-6d5d-4c5a-a7f2-c583d1bff189')
    ]
  end

  describe '#call' do
    context 'when 9 MUG, 1 TSHIRT' do
      let(:cart_items) do
        [
          { product_id: products.first.id, quantity: 9 },
          { product_id: products.second.id, quantity: 1 }
        ]
      end

      expected_result = {
        :products => [
          {
            :code => "MUG",
            :id => "e60b29f9-0e7c-49f3-92e1-a15d82d5430d",
            :name => "Reedsy Mug",
            :price => "6.00",
            :quantity => 9
          },
          {
            :code => "TSHIRT",
            :id => "93a43f44-431d-487f-b3d6-20cc697461af",
            :name => "Reedsy T-shirt",
            :price => "15.00",
            :quantity => 1
          }
        ],
        :total_price => "69.00"
      }

      it 'returns 200 with body containing hash with total price and array of products' do
        result = service.call(cart_items)
        expect(result.code).to eq(200)
        expect(result.body.size).to eq(2)
        expect(result.body[:total_price]).to eq('69.00')
        expect(result.body).to eq(expected_result)
      end
    end

    context 'when 10 MUG, 1 TSHIRT' do
      let(:cart_items) do
        [
          { product_id: products.first.id, quantity: 10 },
          { product_id: products.second.id, quantity: 1 }
        ]
      end

      expected_result = {
        :products => [
          {
            :code => "MUG",
            :id => "e60b29f9-0e7c-49f3-92e1-a15d82d5430d",
            :name => "Reedsy Mug",
            :price => "6.00",
            :quantity => 10
          },
          {
            :code => "TSHIRT",
            :id => "93a43f44-431d-487f-b3d6-20cc697461af",
            :name => "Reedsy T-shirt",
            :price => "15.00",
            :quantity => 1
          }
        ],
        :total_price => "73.80"
      }

      it 'returns 200 with body containing hash with discounted total price and array of products' do
        result = service.call(cart_items)
        expect(result.code).to eq(200)
        expect(result.body.size).to eq(2)
        expect(result.body).to eq(expected_result)
        expect(result.body[:total_price]).to eq('73.80')
      end
    end

    context 'when 45 MUG, 3 TSHIRT' do
      let(:cart_items) do
        [
          { product_id: products.first.id, quantity: 45 },
          { product_id: products.second.id, quantity: 3 }
        ]
      end

      expected_result = {
        :products => [
          {
            :code => "MUG",
            :id => "e60b29f9-0e7c-49f3-92e1-a15d82d5430d",
            :name => "Reedsy Mug",
            :price => "6.00",
            :quantity => 45
          },
          {
            :code => "TSHIRT",
            :id => "93a43f44-431d-487f-b3d6-20cc697461af",
            :name => "Reedsy T-shirt",
            :price => "15.00",
            :quantity => 3
          }
        ],
        :total_price => "279.90"
      }

      it 'returns 200 with body containing hash with discounted total price and array of products' do
        result = service.call(cart_items)
        expect(result.code).to eq(200)
        expect(result.body.size).to eq(2)
        expect(result.body).to eq(expected_result)
        expect(result.body[:total_price]).to eq('279.90')
      end
    end

    context 'when 200 MUG, 4 TSHIRT, 1 HOODIE' do
      let(:cart_items) do
        [
          { product_id: products.first.id, quantity: 200 },
          { product_id: products.second.id, quantity: 4 },
          { product_id: products.last.id, quantity: 1 }
        ]
      end

      expected_result = {
        :products => [
          {
            :code => "MUG",
            :id => "e60b29f9-0e7c-49f3-92e1-a15d82d5430d",
            :name => "Reedsy Mug",
            :price => "6.00",
            :quantity => 200
          },
          {
            :code => "TSHIRT",
            :id => "93a43f44-431d-487f-b3d6-20cc697461af",
            :name => "Reedsy T-shirt",
            :price => "15.00",
            :quantity => 4
          },
          {
            :code => "HOODIE",
            :id => "3181394d-6d5d-4c5a-a7f2-c583d1bff189",
            :name => "Reedsy Hoodie",
            :price => "20.00",
            :quantity => 1
          }
        ],
        :total_price => "902.00"
      }

      it 'returns 200 with body containing hash with discounted total price and array of products' do
        result = service.call(cart_items)
        expect(result.code).to eq(200)
        expect(result.body.size).to eq(2)
        expect(result.body).to eq(expected_result)
        expect(result.body[:total_price]).to eq('902.00')
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
