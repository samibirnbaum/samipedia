Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  
  root "welcome#index"

  resources :wikis do
    resources :collaborators, only: [:create, :destroy]
  end

  resources :charges, only:[:new, :create]

  
  post '/account/upgrade', to: 'accounts#upgrade_account', as: 'account_upgrade'
  post '/account/downgrade', to: 'accounts#downgrade_account', as: 'account_downgrade'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end