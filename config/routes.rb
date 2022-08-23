Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  root to: "pages#home"

  resources :orders, except: :index do
    member do
      get 'change'
      get 'recap'
      get 'success'
      get 'paiement'
    end
  end
  get '/orders/', to: 'orders#new'

  resources :order_documents, only: :create
  resources :users, only: %i[show index edit update] do
    member do
      get 'control_password'
      patch 'control_password_check'
    end
  end
  resources :order_accounts, only: %i[show edit]

  resources :pages do
    collection do
      get 'price'
    end
  end

  resources :messages, only: %i[new create], path: 'contact'

  mount RailsAdmin::Engine, at: '/admin', as: 'rails_admin'
  mount StripeEvent::Engine, at: '/paiement-success'
end
