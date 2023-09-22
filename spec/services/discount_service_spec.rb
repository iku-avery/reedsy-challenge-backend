# spec/services/discount_service_spec.rb

require 'rails_helper'

RSpec.describe DiscountService do
  let(:service) { described_class.new }

  describe '#apply' do
    context 'when eligible for a 30% discount on TSHIRT items' do
        it 'applies a 30% discount' do
        product = FactoryBot.create(:product, price: 15.00, code: 'TSHIRT')
        cart_item = { product_id: product.id, quantity: 3 }
        service = described_class.new(product, cart_item)
        expect(service.apply).to eq(31.5)
        end
    end

    context 'when eligible for a 2% discount on MUG items' do
        it 'applies a 2% discount' do
          product = FactoryBot.create(:product, price: 6.00, code: 'MUG')
          cart_item = { product_id: product.id, quantity: 10 }
          service = described_class.new(product, cart_item)
          expect(service.apply).to eq(58.8)
        end
    end

    context 'when eligible for a 8% discount on MUG items' do
        it 'applies a 8% discount' do
          product = FactoryBot.create(:product, price: 6.00, code: 'MUG')
          cart_item = { product_id: product.id, quantity: 45 }
          service = described_class.new(product, cart_item)
          expect(service.apply).to eq(248.4)
        end
    end

    context 'when eligible for a 30% discount on 150 or more items' do
        it 'applies a 30% discount' do
          product = FactoryBot.create(:product, price: 6.00, code: 'MUG')
          cart_item = { product_id: product.id, quantity: 150 }
          service = described_class.new(product, cart_item)
          expect(service.apply).to eq(630.0)
        end
    end

    context 'when not eligible for a discount' do
      it 'calculates the original price' do
        product = FactoryBot.create(:product, price: 6.00, code: 'MUG')
        cart_item = { product_id: product.id, quantity: 5 }
        service = described_class.new(product, cart_item)
        expect(service.apply).to eq(30.00)
      end
    end
  end
end
