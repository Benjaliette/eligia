Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :orders, except: %i[index show] do
    member do
      get 'recap'
    end
    resources :order_accounts, only: %i[new create destroy]
    resources :order_documents, except: %i[index destroy]
  end

  resources :users, only: :show do
    resources :orders, only: :show
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
