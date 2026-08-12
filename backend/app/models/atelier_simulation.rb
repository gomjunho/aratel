class AtelierSimulation < ApplicationRecord
  validates :flat_map_id, presence: true
  validates :simulation_id, presence: true, uniqueness: true

  before_validation :set_defaults

  def as_created_json
    {
      simulation_id: simulation_id,
      club_deal_triggered: club_deal_triggered,
      club_deal_id: club_deal_id
    }
  end

  private

  def set_defaults
    self.simulation_id ||= "sim_#{rand(8000..9999)}"
    self.club_deal_triggered = true if club_deal_triggered.nil?
    self.club_deal_id ||= "deal_552"
  end
end
