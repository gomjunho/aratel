class FurnitureSimulation < ApplicationRecord
  belongs_to :user, optional: true
  validates :simulation_id, presence: true, uniqueness: true
end
