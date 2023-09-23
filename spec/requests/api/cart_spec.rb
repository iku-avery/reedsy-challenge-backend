require 'rails_helper'

RSpec.describe 'Cart API', type: :request do
  let!(:products) do
    [
      FactoryBot.create(:product, price: 11.99),
      FactoryBot.create(:product, price: 18.05)
    ]
  end

  describe 'POST /api/cart' do
    it 'adds items to the cart' do
      cart_items = [
        { product_id: products.first.id, quantity: 2 },
        { product_id: products.second.id, quantity: 1 }
      ]

      post '/api/cart', params: { products: cart_items }.to_json, headers: { 'Content-Type' => 'application/json' }
      
      expect(response).to have_http_status(200)
      cart_response = JSON.parse(response.body)

      expect(cart_response['products'].size).to eq(2)
      expect(cart_response['total_price']).to eq('42.03')
    end

    it 'returns a 404 response for not existing product' do
      post '/api/cart', params: { products: [{ product_id: 'not_existing_id', quantity: 1 }] }.to_json, headers: { 'Content-Type' => 'application/json' }

      expect(response).to have_http_status(404)
      error_response = JSON.parse(response.body)
      expect(error_response['error']).to eq('Product not found')
    end

    it 'returns a 400 response for negative quantity' do
      post '/api/cart', params: { products: [{ product_id: products.first.id, quantity: -1 }] }.to_json, headers: { 'Content-Type' => 'application/json' }

      expect(response).to have_http_status(400)
      error_response = JSON.parse(response.body)
      expect(error_response['error']).to eq('Quantity must be a positive number')
    end

    it 'returns a 400 response for invalid request parameters' do
      post '/api/cart', params: { products: [] }.to_json, headers: { 'Content-Type' => 'application/json' }

      expect(response).to have_http_status(400)
      error_response = JSON.parse(response.body)
      expect(error_response['error']).to eq('Invalid request parameters')
    end
  end
end
