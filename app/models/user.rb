class User < ApplicationRecord
  has_one :play_signal

  validates :username, presence: true, uniqueness: true
end
