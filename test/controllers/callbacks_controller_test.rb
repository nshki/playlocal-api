class CallbacksControllerTest < ActionDispatch::IntegrationTest
  test 'redirects to expected path with existing user' do
    user = users(:tohfoo)
    auth_hash = {
      uid: user.twitter_uid,
      provider: 'twitter',
      info: {
        nickname: user.twitter_username,
        image: user.twitter_image_url,
      },
    }
    jwt = Auth.encode(user, auth_hash[:provider])
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

    user = User.find_by(twitter_uid: '12345')
    assert user.present?
    assert user.username = 'newuser'
    assert user.twitter_uid = '12345'
    assert user.twitter_username = 'newuser'
  end
end
