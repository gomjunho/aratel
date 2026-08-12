class FurnitureCatalog < ApplicationRecord
  validates :furniture_id, presence: true, uniqueness: true
end
