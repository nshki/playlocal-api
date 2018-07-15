require 'test_helper'

class AuthTest < ActiveSupport::TestCase
  test '.encode returns a string' do
    user = users(:tohfoo)
    assert Auth.encode(user).class == String
  end

  test '.decode works correctly' do
    user = users(:tohfoo)
    jwt = Auth.encode(user)
    jwt_decoded = Auth.decode(jwt)
    assert jwt_decoded['id'] == user.id
  end
end
