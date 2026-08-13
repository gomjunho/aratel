class ProfilesController < ApplicationController
  def show
    @user = current_user
    @complex = ResidentialComplex.find_by(name: @user.complex_name)
    @tier_evidences = @user.tier_evidences.order(created_at: :desc)
    @delegated_accesses = @user.delegated_access_requests.order(created_at: :desc)
  end
end
