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

  resources :orders, path: 'resiliations', path_names: { edit: 'contrats', show: "recapitulatif" }, except: %i[index] do
    member do
      get :show_invoice_pdf
    end

    resources :order_documents, path: 'documents', only: %i[update] do
      member do
        patch 'update_documents'
      end
    end

    resources :order_accounts, path: 'contrats', only: :show do
      resources :order_documents, path: 'documents', only: %i[update]
    end
  end

  namespace :documents do
    resources :orders, path: 'resiliations', path_names: { edit: 'ajout' }, only: %i[edit update]
  end

  namespace :paiement do
    resources :orders, path: 'resiliations', only: %i[show update]
  end

  namespace :users, path: 'utilisateurs' do
    resources :orders, path: 'resiliations', only: :show
  end

  resources :order_accounts, only: %i[create destroy]
  resources :accounts, only: %i[create]

  resources :users, path: 'utilisateurs', path_names: { edit: 'modification' }, only: %i[show index edit update] do
    member do
      get :control_password, path: 'controle'
      patch 'control_password_check'
    end
    resources :orders, path: 'resiliations', only: :index
  end

  resources :order_documents, only: :create

  resources :pages, only: :index do
    collection do
      get :price, path: 'tarifs'
      get :cgu
      get :cgs
    end
  end

  resources :helps, path: 'aide', only: :index do
    collection do
      get :contrats
      get :documents
      get :recapitulatif
      get :tarifs
    end
  end

  resources :messages, path: 'contact', path_names: { new: 'nous-contacter' }, only: %i[new create]

  resources :notifications, only: %i[show destroy] do
    collection do
      patch :mark_as_read
    end
  end

  resources :blogposts, path: 'blog', only: %i[index show new create edit update destroy]

  get '/sitemap.xml.gz', to: redirect("https://storage.googleapis.com/eligia_sitemaps/sitemap.xml.gz")

  mount RailsAdmin::Engine, at: '/admin', as: 'rails_admin'

  post 'merci_facteurs/hC3A7dp5EC3A7uufohqsjoidf', to: 'merci_facteurs#webhook', as: 'merci_facteur_webhook'
end
