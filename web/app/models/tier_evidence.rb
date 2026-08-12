class TierEvidence < ApplicationRecord
  belongs_to :user

  validates :evidence_type, presence: true
  validates :document_url, presence: true
  validates :submission_id, presence: true

  before_validation :set_defaults, if: :new_record?

  def set_defaults
    self.submission_id ||= "sub_#{SecureRandom.hex(4)}"
    self.status ||= "UNDER_REVIEW"
    self.submitted_at ||= Time.current
  end

  def approve!(options = {})
    notes = options.is_a?(Hash) ? options[:admin_notes] : options
    self.status = "VERIFIED"
    self.reviewed_at = Time.current
    self.admin_notes = notes if notes.present?
    user.tier = target_tier
    badge_to_add = case target_tier
    when "DIAMOND" then "DIAMOND_BLACK"
    when "PLATINUM" then "PLATINUM_SILVER"
    when "GOLD" then "GOLD_EMBLEM"
    else "BRONZE_METALLIC"
    end
    user.add_badge(badge_to_add)
    user.save!
    save!
  end

  def reject!(options = {})
    notes = options.is_a?(Hash) ? options[:admin_notes] : options
    self.status = "REJECTED"
    self.reviewed_at = Time.current
    self.admin_notes = notes if notes.present?
    save!
  end

  def self.ransackable_attributes(auth_object = nil)
    ["admin_notes", "created_at", "document_url", "evidence_type", "id", "instagram_handle", "referral_code", "status", "submission_id", "target_tier", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
