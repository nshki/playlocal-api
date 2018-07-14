class CallbacksControllerTest < ActionDispatch::IntegrationTest
  def setup
    user = users(:tohfoo)
    auth_hash = {
      uid: user.twitter_uid,
      provider: 'twitter',
      info: {
        nickname: user.twitter_username,
        image: user.twitter_image_url,
      },
    }
    @jwt = Auth.encode(user, auth_hash[:provider])
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(auth_hash)
  end

  test 'redirects to expected path' do
    get '/auth/twitter'
    follow_redirect!
    assert_redirected_to "#{ENV['CLIENT_URL']}?token=#{@jwt}"
  end
end
