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

To retrieve a list of available products, you can use the following `curl` command:

```shell
curl -X 'GET' \
  'http://localhost:3000/api/products' \
  -H 'accept: application/json'
```