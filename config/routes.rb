Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :orders, except: :index do
    member do
      get 'recap'
      get 'paiement'
    end
    resources :order_documents, except: %i[index destroy]
  end

  resources :users, only: :show do
    resources :orders, only: :show
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount StripeEvent::Engine, at: '/paiement-success'
end
