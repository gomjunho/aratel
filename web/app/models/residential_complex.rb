class ResidentialComplex < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :primary_color, :secondary_color, :accent_color, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "primary_color", "secondary_color", "accent_color", "banner_title", "description", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
