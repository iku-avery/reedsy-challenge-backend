require 'rails_helper'

RSpec.describe "Api::Products", type: :request do
  let!(:products) { FactoryBot.create_list(:product, 2) }

  describe 'GET /api/products' do
    before do
      get '/api/products'
    end

    it 'returns a list of all existing products with the correct attributes' do
      expect(response).to have_http_status(200)
      products_response = JSON.parse(response.body)
      
      expect(products_response.size).to eq(2)
      products_response.each_with_index do |product_response, index|
        product = products[index]

        expect(product_response['id']).to eq(product.id)
        expect(product_response['code']).to eq(product.code)
        expect(product_response['name']).to eq(product.name)
        expect(product_response['price']).to eq(product.price.to_s)
        
        expect(product_response['created_at'].to_datetime.to_i).to eq(product.created_at.to_datetime.to_i)
        expect(product_response['updated_at'].to_datetime.to_i).to eq(product.updated_at.to_datetime.to_i)
      end
    end
  end
end
