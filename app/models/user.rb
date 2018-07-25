class User < ApplicationRecord
  after_create :build_signal

  has_many :identities, dependent: :destroy
  has_one :play_signal, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :avatar_platform, inclusion: {
    in: %w(twitter discord),
    allow_blank: true,
  }

  # Given an auth hash return by OmniAuth, create a new User.
  #
  # @param {Hash} hash
  # @return {User}
  def self.create_with_omniauth(hash)
    # Make sure duplicate usernames aren't used.
    username = Identity.get_omniauth_username(hash)
    i = 0
    while User.find_by(username: username).present? do
      i += 1
      username = "#{username}#{i}"
    end

    # Create and return the User.
    User.create(
      username: username,
      avatar_platform: hash[:provider],
    )
  end

  protected

    # Build an associated PlaySignal.
    #
    # @return {Boolean}
    def build_signal
      self.build_play_signal(
        message: '',
        published: false
      ).save(validate: false)
    end
end
