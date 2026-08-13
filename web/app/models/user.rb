class User < ApplicationRecord
  has_many :delegated_access_requests, dependent: :destroy
  has_many :tier_evidences, dependent: :destroy

  serialize :badges_list, coder: JSON

  after_initialize :set_defaults, if: :new_record?

  def self.ransackable_attributes(auth_object = nil)
    ["badge", "badges_list", "birth_date", "building_number", "complex_name", "created_at", "id", "name", "ownership_percentage", "phone_number", "privacy_masked", "screen_capture_prevented", "tier", "unit_number", "updated_at", "verification_token", "verified_identity_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["tier_evidences", "delegated_access_requests"]
  end

  def badge
    (self[:badge] if has_attribute?(:badge)).presence || "UNVERIFIED"
  end

  def set_defaults
    self.tier ||= "BRONZE"
    self.badge ||= "UNVERIFIED"
    self.screen_capture_prevented = true if screen_capture_prevented.nil?
    self.privacy_masked = true if privacy_masked.nil?
    self.badges_list = ["BRONZE_METALLIC"] if badges_list.blank?
  end

  def badges
    badges_list || []
  end

  def add_badge(badge_name)
    list = badges
    unless list.include?(badge_name)
      list << badge_name
      self.badges_list = list
    end
  end

  def masked_name
    return "" if name.blank?
    if name.length <= 2
      "#{name[0]}*"
    else
      "#{name[0]}#{"*" * (name.length - 2)}#{name[-1]}"
    end
  end

  def masked_phone
    return "" if phone_number.blank?
    phone_number.gsub(/(\d{3})\d{4}(\d{4})/, '\1-****-\2')
  end

  def masked_unit
    "#{building_number} ***호"
  end

  def verify_identity!
    self.verification_token = "ver_tok_#{SecureRandom.hex(4)}"
    self.verified_identity_at = Time.current
    save!
  end

  def sync_trust_api!(complex_name:, building_number:, unit_number:)
    self.complex_name = complex_name
    self.building_number = building_number
    self.unit_number = unit_number
    self.ownership_percentage = 100
    self.badge = "VERIFIED_OWNER"
    self.tier = "GOLD" if tier == "BRONZE"
    add_badge("VERIFIED_OWNER")
    add_badge("GOLD_EMBLEM") if tier == "GOLD"
    save!
  end

  def security_profile
    {
      screen_capture_prevented: screen_capture_prevented,
      privacy_masked: privacy_masked
    }
  end
end
