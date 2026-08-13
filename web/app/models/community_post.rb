class CommunityPost < ApplicationRecord
  belongs_to :user, optional: true

  validates :board_type, presence: true, inclusion: { in: ["GLOBAL", "COMPLEX_NAMED", "COMPLEX_ANONYMOUS"] }
  validates :title, :content, presence: true

  def author_display_name
    case board_type
    when "GLOBAL"
      "#{complex_name.presence || '전체단지'} - #{nickname.presence || '입주민'}"
    when "COMPLEX_NAMED"
      "#{building_number.presence || '101동'} - #{nickname.presence || '입주민'}"
    when "COMPLEX_ANONYMOUS"
      "익명 (AI Clean Signal)"
    else
      nickname.presence || "입주민"
    end
  end

  def board_type_emoji_badge
    case board_type
    when "GLOBAL"
      "🌐 [전체공동]"
    when "COMPLEX_NAMED"
      "🏢 [단지기명]"
    when "COMPLEX_ANONYMOUS"
      "🔒 [단지익명]"
    else
      "📋 [기타]"
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "board_type", "complex_name", "building_number", "nickname", "is_anonymous", "title", "content", "user_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
