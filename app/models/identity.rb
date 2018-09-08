class Identity < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, :username, presence: true

  # Given an auth hash returned by OmniAuth, attempt to locate an instance.
  #
  # @param {Hash} hash
  # @return {Identity | nil}
  def self.find_with_omniauth(hash)
    identity = Identity.find_by(provider: hash[:provider], uid: hash[:uid])

    # If the username or avatar has changed, update them.
    if identity.present? && hash[:info].present?
      username = Identity.get_omniauth_username(hash)
      identity.username = username if identity.username != username
      identity.image_url = hash[:info][:image]
      identity.save
    end

    identity
  end

  # Given an auth hash returned by OmniAuth, attach a new instance to a User.
  #
  # @param {Hash} hash
  # @param {User} user
  # @return {Identity}
  def self.create_with_omniauth(hash, user)
    user ||= User.create_with_omniauth(hash)
    user.identities.create(
      provider: hash[:provider],
      uid: hash[:uid],
      username: get_omniauth_username(hash),
      image_url: hash[:info][:image],
    )
  end

  # Given an auth hash returned by OmniAuth, returns the correct username string
  # based on provider.
  #
  # @param {Hash} hash
  # @return {String}
  def self.get_omniauth_username(hash)
    case hash[:provider]
    when 'twitter'
      hash[:info][:nickname]
    when 'discord'
      subhash = hash[:extra][:raw_info]
      "#{subhash[:username]}##{subhash[:discriminator]}"
    end
  end
end
