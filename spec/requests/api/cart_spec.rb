require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/cart', type: :request do
  let!(:products) do
    [
      FactoryBot.create(:product, price: 11.99),
      FactoryBot.create(:product, price: 18.05)
    ]
  end

  path '/api/cart' do
    post('add items to cart') do
      operationId 'addToCart'
      parameter name: :products, in: :body, schema: {
        type: :array,
        items: {
          type: :object,
          properties: {
            product_id: { type: :integer },
            quantity: { type: :integer }
          },
          required: %w[product_id quantity]
        }
      }      

      let(:cart_items) do
        [
          { product_id: products.first.id, quantity: 2 },
          { product_id: products.second.id, quantity: 1 }
        ]
      end

      response(200, 'successful') do
        examples 'application/json' => 
          {
            products: [
              {
                id: '11kdkk111',
                code: 'MUG',
                name: 'Reedsy Mug',
                price: '6.00',
                quantity: 2
              },
              {
                id: '31kdkk222',
                code: 'TSHIRT',
                name: 'Reedsy T-shirt',
                price: '15.00',
                quantity: 1
              }
            ],
            total_price: '27.00'
          }

        before do
          post '/api/cart', params: { products: cart_items }.to_json, headers: { 'Content-Type' => 'application/json' }
        end

        it 'returns a 200 response' do
          expect(response).to have_http_status(200)
          cart_response = JSON.parse(response.body)

          expect(cart_response['products'].size).to eq(2)
          expect(cart_response['total_price']).to eq('42.03')
        end
      end

      response(404, 'not found') do
        examples 'application/json' => 
          {
            error: 'Product not found'
          }
      
        before do
          post '/api/cart', params: { products: [{ product_id: 'not_existing_id', quantity: 1 }] }.to_json, headers: { 'Content-Type' => 'application/json' }
        end
      
        it 'returns a 404 response for not existing product' do
          expect(response).to have_http_status(404)
          error_response = JSON.parse(response.body)
          expect(error_response['error']).to eq('Product not found')
        end
      end

      response(400, 'bad request') do
        examples 'application/json' => 
          {
            error: 'Quantity must be a positive number'
          }
      
        before do
          post '/api/cart', params: { products: [{ product_id: products.first.id, quantity: -1 }] }.to_json, headers: { 'Content-Type' => 'application/json' }
        end
      
        it 'returns a 400 response for negative quantity' do
          expect(response).to have_http_status(400)
          error_response = JSON.parse(response.body)
          expect(error_response['error']).to eq('Quantity must be a positive number')
        end
      end
      
      response(400, 'bad request') do
        examples 'application/json' => 
          {
            error: 'Invalid request parameters'
          }
      
        before do
          post '/api/cart', params: { products: [] }.to_json, headers: { 'Content-Type' => 'application/json' }
        end
      
        it 'returns a 400 response for invalid request parameters' do
          expect(response).to have_http_status(400)
          error_response = JSON.parse(response.body)
          expect(error_response['error']).to eq('Invalid request parameters')
        end
      end      
      
    end
  end
end
