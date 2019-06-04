Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :uses, only: [:new, :create]
  resources :appliances, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :projects, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
