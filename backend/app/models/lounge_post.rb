class LoungePost < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :post_id, presence: true, uniqueness: true

  before_validation :sanitize_payload
  before_validation :set_defaults


  def as_feed_json
    {
      id: post_id,
      anonymous_nickname: anonymous_nickname,
      verified_badge: verified_badge,
      tier: tier,
      complex_name: complex_name,
      title: title,
      content_encrypted: content_encrypted,
      is_diamond_weighted: is_diamond_weighted,
      trust_score: trust_score,
      created_at: created_at&.iso8601
    }
  end

  def as_created_json
    {
      id: post_id,
      clean_signal_verified: clean_signal_verified,
      earned_points: earned_points,
      status: status
    }
  end

  private

  def sanitize_payload
    self.title = ActionController::Base.helpers.sanitize(title) if title.present?
    self.content = ActionController::Base.helpers.sanitize(content) if content.present?
    self.content_encrypted = ActionController::Base.helpers.sanitize(content_encrypted) if content_encrypted.present?
  end

  def set_defaults

    self.post_id ||= "post_#{rand(7000..9999)}"
    self.anonymous_nickname ||= "은밀한 자산가 42"
    self.verified_badge ||= "VERIFIED_OWNER"
    self.tier ||= "DIAMOND"
    self.complex_name ||= "디에이치 방배"
    self.content_encrypted ||= "EncryptedBodyPayload..."
    self.is_diamond_weighted = true if is_diamond_weighted.nil?
    self.trust_score ||= 98
    self.clean_signal_verified = true if clean_signal_verified.nil?
    self.earned_points ||= 50
    self.status ||= "PUBLISHED"
  end
end
