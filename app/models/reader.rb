class Reader < ApplicationRecord
  validates :public_key, presence: true
end
