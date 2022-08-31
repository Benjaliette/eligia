Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  root to: "pages#home"

  resources :orders, except: %i[index update] do
    member do
      get 'change'
      patch 'update'
      patch 'update_documents'
      get 'recap'
      get 'success'
      get 'paiement'
    end
  end

  # Redirect to orders/new if there is a refresh after a render :new
  get '/orders/', to: 'orders#new'

  resources :users, only: %i[show index edit update] do
    member do
      get 'control_password'
      patch 'control_password_check'
    end
  end

  resources :order_accounts, only: :show do
    resources :order_documents, only: %i[index update]
  end
  resources :order_documents, only: :create

  resources :pages do
    collection do
      get 'price'
    end
  end

  resources :messages, only: %i[new create], path: 'contact'

  mount RailsAdmin::Engine, at: '/admin', as: 'rails_admin'
  mount StripeEvent::Engine, at: '/paiement-success'
end
