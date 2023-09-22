Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    resources :products, only: [:index, :update]
    post '/cart', to: 'cart#checkout'
  end
end
