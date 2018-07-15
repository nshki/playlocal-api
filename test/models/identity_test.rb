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

  test '.create_with_omniauth creates associated User and instance' do
    hash = {
      provider: 'twitter',
      uid: 'testuid',
      info: {
        nickname: 'testname',
        image_url: '',
      },
    }
    Identity.create_with_omniauth(hash)

    user = User.find_by(username: 'testname')
    assert user.present?
    assert user.identities.find_by(provider: 'twitter', uid: 'testuid').present?
  end

  test '.get_omniauth_username gets correct username based on provider' do
    twitter_hash = {
      provider: 'twitter',
      uid: 'testuid',
      info: {
        nickname: 'testname',
        image_url: '',
      },
    }
    discord_hash = {
      provider: 'discord',
      uid: 'testuid',
      extra: {
        raw_info: {
          username: 'teehee',
          discriminator: '123',
        },
      },
    }
    assert Identity.get_omniauth_username(twitter_hash) == 'testname'
    assert Identity.get_omniauth_username(discord_hash) == 'teehee#123'
  end
end
