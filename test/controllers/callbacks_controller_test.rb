class CallbacksControllerTest < ActionDispatch::IntegrationTest
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
    user.save
    identity = user.identities.find_by(provider: 'twitter')
    user_updated_at = user.updated_at
    identity_updated_at = identity.updated_at
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      uid: identity.uid,
      provider: identity.provider,
      info: {
        nickname: identity.username,
        image: identity.image_url,
      },
    )

    get '/auth/discord'
    follow_redirect!

    assert user.updated_at == user_updated_at
    assert identity.updated_at == identity.updated_at
  end

  test '#handle existing User existing Identity on another User' do
    origin_user = users(:tohfoo)
    origin_user.save
    identity = identities(:brianydg_twitter)
    token = Auth.encode(origin_user)
    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new(
      uid: identity.uid,
      provider: identity.provider,
      info: {
        nickname: identity.username,
        image: identity.image_url,
      },
    )

    get "/auth/discord?token=#{token}"
    follow_redirect!

    assert identity.reload.user == origin_user
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
