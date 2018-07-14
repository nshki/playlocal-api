require 'test_helper'

class AuthTest < ActiveSupport::TestCase
  test '#encode returns a string' do
    user = users(:tohfoo)
    assert Auth.encode(user, 'twitter').class == String
  end

  test '#decode works correctly' do
    user = users(:tohfoo)
    jwt = Auth.encode(user, 'twitter')
    jwt_decoded = Auth.decode(jwt)
    assert jwt_decoded['provider'] == 'twitter'
    assert jwt_decoded['uid'] == user.twitter_uid
  end
end
