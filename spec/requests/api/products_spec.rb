require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  let!(:products) { FactoryBot.create_list(:product, 2) }

  describe 'GET /api/products' do
    it 'returns a list of products' do
      get '/api/products'
      expect(response).to have_http_status(200)
      
      products_response = JSON.parse(response.body)
      expect(products_response.size).to eq(2)

      products_response.each_with_index do |product_response, index|
        product = products[index]
        product_response = product_response.with_indifferent_access

        expect(product_response[:id]).to eq(product.id)
        expect(product_response[:code]).to eq(product.code)
        expect(product_response[:name]).to eq(product.name)
        expect(product_response[:price]).to eq(product.price.to_s)

        expect(product_response[:created_at].to_datetime.to_i).to eq(product.created_at.to_datetime.to_i)
        expect(product_response[:updated_at].to_datetime.to_i).to eq(product.updated_at.to_datetime.to_i)
      end
    end
  end

  describe 'PUT /api/products/{id}' do
    let(:id) { products.first.id }
    let(:price) { 11.99 }

    it 'updates product price' do
      request_body = {
        product: {
          price: price
        }
      }

      put "/api/products/#{id}", params: request_body.to_json, headers: { 'Content-Type' => 'application/json' }
      
      expect(response).to have_http_status(200)
      updated_product = JSON.parse(response.body)
      expect(updated_product['price'].to_f).to eq(price)
    end

    it 'returns a 404 response when product is not found' do
      invalid_id = 'invalid_id'
      request_body = {
        product: {
          price: price
        }
      }

      put "/api/products/#{invalid_id}", params: request_body.to_json, headers: { 'Content-Type' => 'application/json' }

      expect(response).to have_http_status(404)
      error_response = JSON.parse(response.body)
      expect(error_response['error']).to eq('Product not found')
    end

    it 'returns a 400 response when price is invalid' do
      invalid_price = -1
      request_body = {
        product: {
          price: invalid_price
        }
      }

      put "/api/products/#{id}", params: request_body.to_json, headers: { 'Content-Type' => 'application/json' }

      expect(response).to have_http_status(400)
      error_response = JSON.parse(response.body)
      expect(error_response['error']).to eq('Price must be a positive number')
    end
  end
end
