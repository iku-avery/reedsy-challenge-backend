# README

# Store API

Store API is a Ruby on Rails application that provides a simple API for managing a Reedsy's (fictional) Merchandising Store.

## Guide

- [Development](#development)
  - [Dependencies](#dependencies)
  - [Installation](#installation)

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


