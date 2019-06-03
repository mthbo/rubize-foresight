Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :appliances, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :projects, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
