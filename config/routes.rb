Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  namespace :admin do
    resources :users, only: [:index, :update]
  end

  resources :uses, only: [:new, :create, :edit, :update, :destroy]
  resources :appliances, only: [:index, :show, :new, :create, :edit, :update, :destroy], shallow: true do
    resources :sources, only: [:new, :create, :edit, :update, :destroy]
  end
  get '/refresh_load', to: 'appliances#refresh_load'

  resources :projects, only: [:index, :show, :new, :create, :edit, :update, :destroy], shallow: true do
    resources :project_appliances, only: [:index, :new, :create, :edit, :update, :destroy]
  end
end
