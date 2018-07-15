class User < ApplicationRecord
  has_many :identities
  has_one :play_signal

  validates :username, presence: true, uniqueness: true
  validates :avatar_platform, presence: true, inclusion: {
    in: %w(twitter discord)
  }

  # Given an auth hash return by OmniAuth, create a new User.
  #
  # @param {Hash} hash
  # @return {User}
  def self.create_with_omniauth(hash)
    User.create(
      username: hash[:info][:nickname],
      avatar_platform: hash[:provider],
    )
  end
end
