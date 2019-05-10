Rails.application.routes.draw do
  post 'cart/add_to_cart'
  get 'cart/show'
  post 'cart/edit'
  get 'cart/delete'
  get 'reports/sales'
  get 'reports/top_customers'
  get 'reports/best_selling'
  root 'sessions#new'
  get 'sessions/new'
  get 'orders/confirm'
  get 'users/promote'
  get 'users/demote'
  get 'orders/unconfirm'
  resources :users
  resources :purchases , only: [:index, :show] do
    collection do
      get 'checkout'
      get 'confirm_checkout'
    end
  end
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
