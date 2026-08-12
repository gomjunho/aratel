Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "verifications#show"

  resource :verification, only: [:show] do
    post :identity_verify
    post :trust_api_sync
  end

  resources :delegated_accesses, only: [:create] do
    member do
      post :approve
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
        post :tier_evidence, to: "/tier_evidences#api_create"
      end

      namespace :users do
        get "me/tier", to: "/verifications#api_me_tier"
      end
    end
  end
end
