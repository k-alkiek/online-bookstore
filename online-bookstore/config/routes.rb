Rails.application.routes.draw do
  root 'sessions#new'
  get 'sessions/new'
  get 'orders/confirm'
  get 'orders/unconfirm'
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
