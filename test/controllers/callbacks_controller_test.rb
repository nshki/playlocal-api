class CallbacksControllerTest < ActionDispatch::IntegrationTest
  test 'redirects to expected path with existing user' do
    user = users(:tohfoo)
    identity = user.identities.find_by(provider: 'twitter')
    auth_hash = {
      uid: identity.uid,
      provider: identity.provider,
      info: {
        nickname: identity.username,
        image: identity.image_url,
      },
    }
    jwt = Auth.encode(user)
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(auth_hash)

    get '/auth/twitter'
    follow_redirect!

    assert_redirected_to "#{ENV['CLIENT_URL']}?token=#{jwt}"
  end

  test 'redirects to expected path with new user' do
    auth_hash = {
      uid: '12345',
      provider: 'twitter',
      info: {
        nickname: 'newuser',
        image: '',
      },
    }
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(auth_hash)

    get '/auth/twitter'
    follow_redirect!

    identity = Identity.find_by(provider: 'twitter', uid: '12345')
    user = identity && identity.user.present? ? identity.user : User.new
    assert user.present? && user.valid? && user.username == 'newuser'
    assert identity.present? && identity.provider == 'twitter' &&
           identity.uid == '12345' && identity.username == 'newuser'
  end
end
