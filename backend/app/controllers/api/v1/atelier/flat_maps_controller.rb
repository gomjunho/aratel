module Api
  module V1
    module Atelier
      class FlatMapsController < ApplicationController
        def index
          render json: AtelierCatalog.fetch_flat_maps, status: :ok
        end
      end
    end
  end
end
