# README

# Store API

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
    git clone git@github.com:iku-avery/store_api.git && cd store_api
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

The API documentation for the Store API can be accessed via Swagger. 

While running the application locally, you can access the documentation at the following URL:

```shell
    http://localhost:3000/api-docs/
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

----