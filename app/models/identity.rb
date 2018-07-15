class Identity < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, :username, presence: true

  # Given an auth hash returned by OmniAuth, attempt to locate an instance.
  #
  # @param {Hash} hash
  # @return {Identity | nil}
  def self.find_with_omniauth(hash)
    Identity.find_by(provider: hash[:provider], uid: hash[:uid])
  end

  # Given an auth hash returned by OmniAuth, attach a new instance to a User.
  #
  # @param {Hash} hash
  # @return {Identity}
  def self.create_with_omniauth(hash)
    user ||= User.create_with_omniauth(hash)
    user.identities.create(
      provider: hash[:provider],
      uid: hash[:uid],
      username: hash[:info][:nickname],
      image_url: hash[:info][:image],
    )
  end
end
