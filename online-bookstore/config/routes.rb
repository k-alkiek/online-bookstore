Rails.application.routes.draw do
  post 'cart/add_to_cart'
  get 'cart/show'
  get 'sessions/new'
  resources :users
  resources :purchases
  resources :publishers
  resources :orders
  resources :book_authors
  resources :books
  resources :authors
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
