require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'has a valid factory' do
    product = FactoryBot.create(:product)
    expect(product).to be_valid
  end
end
