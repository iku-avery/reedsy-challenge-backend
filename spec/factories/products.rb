FactoryBot.define do
  factory :product do
     # Generates a unique name for each product
     sequence(:name) { |n| "Product #{n}" }
     # Generate a random price between 5.00 and 20.00
     price { rand(5.00..20.00).round(2) }
     # Define a sequence for the code attribute (e.g., MUG, TSHIRT, HOODIE)
     sequence(:code) { |n| "CODE-#{n}" }
  end
end
