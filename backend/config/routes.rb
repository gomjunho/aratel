Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post "identity_verify", to: "identity_verifications#create"
      end
    end
  end
end
