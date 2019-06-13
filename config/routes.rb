Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  namespace :admin do
    resources :users, only: [:index, :update]
  end

  resources :uses, only: [:new, :create, :edit, :update]
  resources :appliances, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :projects, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
