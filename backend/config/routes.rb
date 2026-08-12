Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post "identity_verify", to: "identity_verifications#create"
      end

      namespace :verification do
        post "trust_api_sync", to: "trust_api_syncs#create"
        post "delegated_access", to: "delegated_accesses#create"
        post "delegated_access/:id/approve", to: "delegated_accesses#approve"
        post "tier_evidence", to: "tier_evidences#create"
      end

      namespace :users do
        get "me/tier", to: "tiers#show"
      end

      namespace :home do
        get "welcome", to: "welcomes#show"
      end

      namespace :ai do
        post "agent_dialogue", to: "agent_dialogues#create"
      end
    end
  end
end
