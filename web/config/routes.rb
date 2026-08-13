Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  get "up" => "rails/health#show", as: :rails_health_check

  root "homes#show"

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  post "demo_login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  resource :profile, only: [:show]

  resource :verification, only: [:show] do
    post :identity_verify
    post :trust_api_sync
  end

  resources :delegated_accesses, only: [:create] do
    member do
      post :approve
      post :reject
    end
  end

  resources :tier_evidences, only: [:new, :create, :show]

  namespace :admin do
    resources :verifications, only: [:index, :show] do
      member do
        post :approve_tier_evidence
        post :reject_tier_evidence
        post :approve_delegation
        post :reject_delegation
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post :identity_verify, to: "/verifications#api_identity_verify"
      end

      namespace :verification do
        post :trust_api_sync, to: "/verifications#api_trust_api_sync"
        post :delegated_access, to: "/delegated_accesses#api_create"
        post "delegated_access/:id/approve", to: "/delegated_accesses#api_approve"
        post "delegated_access/:id/reject", to: "/delegated_accesses#api_approve"
        post :tier_evidence, to: "/tier_evidences#api_create"
      end

      namespace :users do
        get "me/tier", to: "/verifications#api_me_tier"
      end

      get "home/welcome", to: "/homes#api_welcome"
      post "ai/agent_dialogue", to: "/homes#api_agent_dialogue"

      get "lounge/posts", to: "/lounge_posts#api_index"
      post "lounge/posts", to: "/lounge_posts#api_create"

      get "atelier/flat_maps", to: "/ateliers#api_flat_maps"
      post "atelier/simulations", to: "/ateliers#api_create_simulation"

      get "club_deals", to: "/club_deals#api_index"
      post "club_deals/:id/order", to: "/club_deals#api_order", as: :order_api_v1_club_deal
      post "concierge/reservations", to: "/concierges#api_create_reservation"

      get "insights/transactions", to: "/insights#api_transactions"
    end
  end

  resource :curation, only: [:show] do
    post :simulate_atelier
    post :order_club_deal
    post :reserve_concierge
  end

  resource :home, only: [:show] do
    post :agent_dialogue
  end

  resources :lounge_posts, only: [:index, :new, :create]
  resources :community_posts, only: [:index, :new, :create]

  resource :atelier, only: [:show] do
    post :simulate
    post :order_club_deal
  end

  resources :club_deals, only: [:index, :show] do
    member do
      post :order
    end
  end

  resource :concierge, only: [:show] do
    resources :reservations, controller: "concierges", only: [:create]
  end

  resource :insight, only: [:show]

  # ActiveAdmin Dashboard & Resources
  ActiveAdmin.routes(self)
end
