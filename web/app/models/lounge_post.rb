class LoungePost < ApplicationRecord
  validates :post_id, presence: true, uniqueness: true

  before_validation :sanitize_payload

  def self.ransackable_attributes(auth_object = nil)
    ["anonymous_nickname", "clean_signal_verified", "complex_name", "content_encrypted", "created_at", "earned_points", "id", "is_diamond_weighted", "post_id", "status", "tier", "title", "trust_score", "updated_at", "verified_badge"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def sanitize_payload
    self.title = ActionController::Base.helpers.sanitize(title) if title.present?
    self.content_encrypted = ActionController::Base.helpers.sanitize(content_encrypted) if content_encrypted.present?
  end

end
