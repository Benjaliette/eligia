Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  root to: "pages#home"

  resources :orders, except: :index do
    member do
      get 'recap'
      get 'success'
    end
  end
  get '/orders/', to: 'orders#new'
  resources :order_documents, only: :create

  resources :users, only: [:show, :index]

  resources :pages do
    collection do
      get 'price'
    end
  end

  resources :messages, only: %i[new create], path: 'contact'

  mount RailsAdmin::Engine, at: '/admin', as: 'rails_admin'
  mount StripeEvent::Engine, at: '/paiement-success'
end
