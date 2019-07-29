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

  resources :projects, only: [:index, :show, :new, :create, :edit, :update, :destroy], shallow: true do
    resources :project_appliances, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :solar_systems, only: [:new, :create, :edit, :update]
  end

  get 'appliance_refresh_load', to: 'appliances#refresh_load'
  get 'project_appliance_refresh_load', to: 'project_appliances#refresh_load'

  get 'power_components', to: 'pages#power_components'
  resources :power_systems, only: [:new, :create, :edit, :update, :destroy]
  resources :batteries, only: [:new, :create, :edit, :update, :destroy]
  resources :solar_panels, only: [:new, :create, :edit, :update, :destroy]
end
