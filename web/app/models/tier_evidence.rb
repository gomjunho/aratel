class TierEvidence < ApplicationRecord
  belongs_to :user

  before_validation :generate_submission_id, on: :create
  before_validation :set_defaults, on: :create

  def generate_submission_id
    self.submission_id ||= "sub_#{rand(1000..9999)}"
  end

  def set_defaults
    self.status ||= "UNDER_REVIEW"
    self.target_tier ||= "DIAMOND"
    self.submitted_at ||= Time.current
  end

  def approve!(admin_notes: nil)
    update!(
      status: "VERIFIED",
      reviewed_at: Time.current,
      admin_notes: admin_notes
    )
    user.tier = target_tier
    badge_name = case target_tier
                 when "DIAMOND" then "DIAMOND_BLACK"
                 when "PLATINUM" then "PLATINUM_SILVER"
                 when "GOLD" then "GOLD_EMBLEM"
                 else "BRONZE_METALLIC"
                 end
    user.add_badge(badge_name)
    user.save!
  end

  def reject!(admin_notes: nil)
    update!(
      status: "REJECTED",
      reviewed_at: Time.current,
      admin_notes: admin_notes
    )
  end
end
