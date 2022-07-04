Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :orders, except: :index do
    member do
      get 'paiement'
    end
  end
  resources :order_documents, only: :create

  resources :users, only: :show

  mount RailsAdmin::Engine, at: '/admin', as: 'rails_admin'
  mount StripeEvent::Engine, at: '/paiement-success'
end
