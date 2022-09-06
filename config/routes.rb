Rails.application.routes.draw do
  devise_for :users, path: 'utilisateur', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }, path_names: {
    sign_in: 'connexion',
    sign_up: 'inscription',
    edit: 'modification'
  }

  root to: "pages#home"

  resources :orders, path: 'resiliations', path_names: { new: 'contrats', edit: 'documents' }, except: %i[index] do
    member do
      get :change, path: 'contrats'
      patch 'update_documents'
      get :recap, path: 'recapitulatif'
      get 'success'
      get 'paiement'
    end
  end

  # Redirect to orders/new if there is a refresh after a render :new
  get '/resiliations/', to: 'orders#new'

  resources :users, path: 'utilisateurs', path_names: { edit: 'modification' }, only: %i[show index edit update] do
    member do
      get :control_password, path: 'controle'
      patch 'control_password_check'
    end
  end

  resources :order_accounts, path: 'contrats', only: :show do
    resources :order_documents, path: 'documents', only: %i[update]
  end
  resources :order_documents, only: :create

  resources :pages do
    collection do
      get :price, path: 'tarifs'
    end
  end

  resources :messages, path: 'contact', path_names: { new: 'nous-contacter' }, only: %i[new create]

  mount RailsAdmin::Engine, at: '/admin', as: 'rails_admin'
  mount StripeEvent::Engine, at: '/paiement-success'
end
