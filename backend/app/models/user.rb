require "json"

class User < ApplicationRecord
  has_secure_password validations: false

  validates :user_id, presence: true, uniqueness: true
  validates :tier, presence: true

  serialize :badges, coder: JSON, type: Array, default: []

  def self.mask_name(raw_name)
    return "" if raw_name.blank?

    str = raw_name.to_s.strip
    len = str.length
    return str if len <= 1
    return "#{str[0]}*" if len == 2

    "#{str[0]}#{"*" * (len - 2)}#{str[-1]}"
  end

  def badges_list
    badges.is_a?(Array) ? badges : []
  end

  def building_unit
    "#{building_number} #{unit_number}".strip
  end

  def security_profile
    {
      "screen_capture_prevented" => screen_capture_prevented,
      "privacy_masked" => privacy_masked
    }
  end
end
