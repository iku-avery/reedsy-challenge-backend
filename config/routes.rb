Rails.application.routes.draw do
  namespace :api do
    resources :products, only: [:index, :update]
    post '/cart', to: 'cart#checkout'
  end
end
