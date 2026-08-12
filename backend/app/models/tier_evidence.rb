require "securerandom"

class TierEvidence < ApplicationRecord
  validates :evidence_type, presence: true
  validates :document_url, presence: true
  validates :submission_id, presence: true, uniqueness: true

  before_validation :set_defaults

  private

  def set_defaults
    self.submission_id = "sub_#{rand(1000..9999)}" if submission_id.blank?
    self.status ||= "UNDER_REVIEW"
    self.target_tier ||= "DIAMOND"
    self.submitted_at ||= Time.current
  end
end
