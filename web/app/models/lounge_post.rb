class LoungePost < ApplicationRecord
  validates :post_id, presence: true, uniqueness: true
end
