require 'rails_helper'
require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/products', type: :request do
  let!(:products) { FactoryBot.create_list(:product, 2) }

  path '/api/products' do
    get('list products') do
      operationId 'listProducts'

      response(200, 'successful') do
        before do
          get '/api/products'
        end

        examples 'application/json' => [
          {
            id: '11kdkk111',
            code: 'MUG',
            name: 'Reedsy Mug',
            price: '6.00',
            created_at: '2023-09-18T17:15:35Z',
            updated_at: '2023-09-18T17:15:35Z'
          },
          {
            id: '31kdkk222',
            code: 'TSHIRT',
            name: 'Reedsy T-shirt',
            price: '15.00',
            created_at: '2023-09-18T17:15:35Z',
            updated_at: '2023-09-18T17:15:35Z'
          }
        ]

        run_test! do
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
    end
  end
end
