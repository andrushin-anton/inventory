Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sessions
  resources :staff
  resources :users
  resources :item

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'users/password/:id', to: 'users#password', as: 'password'
  patch 'users/update_password/:id', to: 'users#update_password', as: 'update_password'
  patch 'users/activate/:id', to: 'users#activate', as: 'user_activate'

  post 'item_history/:id', to: 'item#item_history_create', as: 'item_history'

  root 'inventory#index'
end
