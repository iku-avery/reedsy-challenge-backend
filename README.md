# README

# Preface 


## about me

I'm a nature-loving nerd with a kid-like enthusiasm who can't help but tell it like it is. Honesty, empathy, and teamwork are my priorities. Being real is super important to me as someone on the autism spectrum. I used to sling coffee, judge it, and even wrote a book about it. I'm pumped to keep going, using my tech skills and passion to do cool stuff that matters.

As for hobbies, I'm a bookworm who loves magical realism, fantasy, sci-fi, and books about social stuff and nature. Nature itself, whether it's by the sea or deep in the forests, is where I find my peace, and I hold a dream close to my heart of one day running an animal sanctuary. Trains, Doctor Who, and sharing my passions with others are my absolute joys. I also find immense satisfaction in hands-on activities like carpentry, pottery, whipping up homemade jams, and tending to my garden.
:seedling: :train: :books: :turtle: :sauropod: :black_cat: :mountain:

## professional experience and commercial projects

I spent several years in a software house, where I contributed to diverse projects. One standout was Firepoint, a Real Estate CRM solution. I worked on exciting features like dialer and call recording, integrations with Zapier and Twilio, and building advanced search tools, IDX, and more. Another highlight was Urb-it, a sustainable logistics platform for eco-friendly last-mile deliveries in Europe. I created an API-only app to integrate Urb-it with various services like Bringg, Woop, and Coop.

Later, at Shopify in the Merchant Services/Delivery Settings team, I focused on enhancing the admin panel. I worked on new features, A/B testing, and "shop promise" functionality. I also optimized the API for larger merchants, addressing performance, queries, and versioning. Additionally, I was part of the team that sorbetized the entire app for improved robustness.

## major achievements

:potted_plant: TBH I don't just measure my achievements by specific milestones. Most of my accomplishments are about the opportunity to learn and grow. I take pride in the fact that every time users can use a new feature and it brings them joy, it's a rewarding achievement in itself.

# Store API reedsy-challenge-backend

Store API is a Ruby on Rails application that provides a simple API for managing a Reedsy's (fictional) Merchandising Store.

## Guide

- [Development](#development)
  - [Dependencies](#dependencies)
  - [Installation](#installation)
- [Testing](#testing)
  - [Running Tests](#running-tests)
- [API Documentation](#api-documentation)

## Development
### Dependencies

- Ruby (3.2.2 recommended)
- Ruby on Rails (7.0 recommended)
- PostgreSQL
- Bundler

### Installation

Assuming you work on macOS and use [rvm]:

1. Install dependencies listed in the [dependencies section](#dependencies)

    ```shell
    rvm install 3.2.2 && rvm use 3.2.2
    brew update
    ```

2. Clone the repository and change the directory:

    ```shell
    git clone git@github.com:iku-avery/reedsy-challenge-backend.git && cd store_api
    bundle install
    ```

3. Setup database:
    ```shell
        rails db:create && rails db:migrate && rails db:seed
    ```


## Testing

To ensure the functionality of the Store API, you can run automated tests using RSpec. 

### Running Tests

Execute the following command to run the tests:

```shell
    bundle exec rspec spec
```

## API Documentation

### Endpoints

#### List Products

- URL: `/api/products`
- Method: GET
- Description: Get a list of all available products.
- Response: Returns a JSON array of products with details including ID, code, name, price, and timestamps.

```shell
[
  {
    "id": "11kdkk111",
    "code": "MUG",
    "name": "Reedsy Mug",
    "price": "6.00",
    "created_at": "2023-09-18T17:15:35Z",
    "updated_at": "2023-09-18T17:15:35Z"
  },
  {
    "id": "31kdkk222",
    "code": "TSHIRT",
    "name": "Reedsy T-shirt",
    "price": "15.00",
    "created_at": "2023-09-18T17:15:35Z",
    "updated_at": "2023-09-18T17:15:35Z"
  }
]
```

#### Update Product Price

- URL: `/api/products/:id`
- Method: UPDATE
- Description: Update the price of a specific product.

- Request Parameters:
  - id (required): The ID of the product to update.
  - product (required): An object containing the new price.

- Request:
```shell
  PUT /api/products/:id
```
- Request body:
```shell
  {
    "product": {
      "price": 8.99
    }
  }
```

- Response: 
  - Returns the updated product with details including ID, code, name, price, and timestamps.
  - Expected Response Code: 200 (OK)
  - Expected Response Body:

  ```shell
    {
      "id": "11kdkk111",
      "code": "MUG",
      "name": "Reedsy Mug",
      "price": "11.99",
      "created_at": "2023-09-18T17:15:35Z",
      "updated_at": "2023-09-18T17:15:35Z"
    }
  ```

- Possible Error Response (404 Not Found):

```shell
  {
    "error": "Product not found"
  }
```


- Possible Error Response (400 Bad Request):

```shell
  {
    "error": "Price must be a positive number"
  }
```


#### Checkout (Add Items to Cart)

- URL: `/api/cart`
- Method: POST
- Description: Add items to the shopping cart.

- Request Parameters:

   - products (required): An array of objects containing product IDs and quantities.

- Request:
```shell
  POST /api/cart
```

- Request body:
```shell
  {
  "products": [
    {
      "product_id": "11kdkk111",
      "quantity": 2
    },
    {
      "product_id": "31kdkk222",
      "quantity": 1
    }
  ]
}
```

- Response: 
  - Returns a JSON object representing the cart, including a list of products added and the total price.
  - Expected Response Code: 200 (OK)
  - Expected Response Body:

```shell
  {
    "products": [
      {
        "id": "11kdkk111",
        "code": "MUG",
        "name": "Reedsy Mug",
        "price": "6.00",
        "quantity": 2
      },
      {
        "id": "31kdkk222",
        "code": "TSHIRT",
        "name": "Reedsy T-shirt",
        "price": "15.00",
        "quantity": 1
      }
    ],
    "total_price": "27.00"
  }
```

- Possible Error Response (404 Not Found - Product Not Found):

```shell
  {
    "error": "Product not found"
  }
```

- Possible Error Response (400 Bad Request - Negative Quantity):

```shell
  {
    "error": "Quantity must be a positive number"
  }
```

- Possible Error Response (400 Bad Request - Invalid Request Parameters):

```shell
  {
    "error": "Invalid request parameters"
  }
```

## Using the API

You can interact with the Store API by making HTTP requests to its endpoints:
### Listing Products

```shell
  GET /api/products
```

To retrieve a list of available products, you can use the following `curl` command:

```shell
curl -X 'GET' \
  'http://localhost:3000/api/products' \
  -H 'accept: application/json'
```

### Update product price

To update the price of a product, use the PUT request on the following endpoint:

  ```shell
    PUT /api/products/{id}
  ```

Replace {id} with the unique identifier of the product you want to update.

The request body should be in JSON format and include the new price of the product:

  ```shell
    {
    "product": {
      "price": 11.99
      }
    }
  ```

You can use the following `curl` commands:

  - Update product price with a 200 response

    ```shell
      curl -X PUT http://localhost:3000/api/products/{id} -H 'Content-Type: application/json' -d '{"product":{"price":11.99}}'
    ```

  - Attempt to update product using invalid id with a 404 response:

    ```shell
      curl -X PUT http://localhost:3000/api/products/not_existing_id -H 'Content-Type: application/json' -d '{"product":{"price":11.99}}'
    ```

  - Attempt to update a product with a negative price with a 400 response

    ```shell
      curl -X PUT http://localhost:3000/api/products/{id} -H 'Content-Type: application/json' -d '{"product":{"price":-11.99}}'
    ```

### Adding Items to Cart

To add items to the cart, use the POST request on the following endpoint:

```shell
  POST /api/cart
```

The request body should be in JSON format and include an array of products with their product_id and quantity:

```shell
  {
  "products": [
    { "product_id": {id}, "quantity": 2 },
    { "product_id": {id}, "quantity": 1 }
    ]
  }
```

You can use the following `curl` commands:

```shell
  curl -X POST http://localhost:3000/api/cart -H 'Content-Type: application/json' -d '{
  "products": [
    { "product_id": {id}, "quantity": 2 },
    { "product_id": {id}, "quantity": 1 }
  ]
}'
```


**Testing with Postman:**

You can also test API using Postman. I've provided a Postman collection that includes pre-configured requests for API endpoints. You can import the collection into Postman and use it to interact with API. The collection includes sample requests, expected responses, and variables for easy testing.

**Postman Collection:** [Download Postman Collection](https://we.tl/t-19yqi2BZ4h)


----