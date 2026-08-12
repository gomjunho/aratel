class LoungePost < ApplicationRecord
  validates :post_id, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["anonymous_nickname", "clean_signal_verified", "complex_name", "content_encrypted", "created_at", "earned_points", "id", "is_diamond_weighted", "post_id", "status", "tier", "title", "trust_score", "updated_at", "verified_badge"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
