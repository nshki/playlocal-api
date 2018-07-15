require 'test_helper'

class IdentityTest < ActiveSupport::TestCase
  test 'valid identity' do
    identity = identities(:tohfoo_twitter)
    assert identity.valid?
  end

  test 'invalid without provider' do
    identity = identities(:tohfoo_twitter)
    identity.provider = ''
    assert !identity.valid?
  end

  test 'invalid without uid' do
    identity = identities(:tohfoo_twitter)
    identity.uid = ''
    assert !identity.valid?
  end

  test 'invalid without username' do
    identity = identities(:tohfoo_twitter)
    identity.username = ''
    assert !identity.valid?
  end
end
