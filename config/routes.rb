Personas::Application.routes.draw do
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'signup', to: 'users#new', as: 'signup'

  match "/oauth/authorize", :via => :get, :to => "authorization#new"
  match "/oauth/authorize", :via => :post, :to => "authorization#create"

  match "/profile" => "users#profile"
  match "/register" => "users#new"

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :users
  resources :password_resets
  resources :sessions

  root :to => "users#new"
end
