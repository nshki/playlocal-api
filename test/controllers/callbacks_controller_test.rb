class CallbacksControllerTest < ActionDispatch::IntegrationTest
  def setup
    OmniAuth.config.mock_auth[:twitter] = nil
    OmniAuth.config.mock_auth[:discord] = nil
  end

  test '#handle new User new Identity' do
    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new(discord_hash)

    get '/auth/discord'
    follow_redirect!

    identity = Identity.find_by(provider: 'discord', uid: '12345')
    user = identity.user
    assert user.present? && user.valid? && user.username == 'discorduser#123'
    assert identity.present? && identity.provider == 'discord' &&
           identity.uid == '12345' && identity.username == 'discorduser#123'
  end

  test '#handle existing User new Identity' do
    user = User.create(username: 'existinguser')
    token = Auth.encode(user)
    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new(discord_hash)

    get "/auth/discord?token=#{token}"
    follow_redirect!

    identity = Identity.find_by(provider: 'discord', uid: '12345')
    assert identity.user == user
  end

  test '#handle existing User existing Identity' do
    user = users(:tohfoo)
    identity = user.identities.find_by(provider: 'twitter')
    updated_ats = { user: user.updated_at, identity: identity.updated_at }
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      uid: identity.uid,
      provider: identity.provider,
    )

    get '/auth/twitter'
    follow_redirect!

    assert user.reload.updated_at == updated_ats[:user]
    assert identity.reload.updated_at == updated_ats[:identity]
  end

  test '#handle existing User existing Identity on another User' do
    origin_user = users(:tohfoo)
    old_user_id = users(:brianydg)
    identity = identities(:brianydg_twitter)
    identities(:brianydg_discord).destroy
    token = Auth.encode(origin_user)
    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new(
      uid: identity.uid,
      provider: identity.provider,
    )

    get "/auth/discord?token=#{token}"
    follow_redirect!

    assert identity.reload.user == origin_user
    assert User.find_by(id: old_user_id) == nil
  end

  def discord_hash
    {
      uid: '12345',
      provider: 'discord',
      info: {
        image: 'https://discordapp.com',
      },
      extra: {
        raw_info: {
          username: 'discorduser',
          discriminator: '123'
        },
      },
    }
  end
end
