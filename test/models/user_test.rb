require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    assert users(:tohfoo).valid?
  end

  test 'has one signal' do
    user = users(:tohfoo)
    assert user.play_signal.class == PlaySignal
  end

  test 'invalid without username' do
    user = users(:tohfoo)
    user.username = ''
    assert !user.valid?
  end

  test 'invalid without unique username' do
    user = users(:tohfoo)
    user.username = users(:brianydg).username
    assert !user.valid?
  end

  test 'avatar_platform can only be blank, twitter, or discord' do
    user = users(:tohfoo)

    user.avatar_platform = ''
    assert user.valid?

    user.avatar_platform = 'twitter'
    assert user.valid?

    user.avatar_platform = 'discord'
    assert user.valid?

    user.avatar_platform = 'notvalid'
    assert !user.valid?
  end

  test 'builds associated PlaySignal on create' do
    user = User.create(username: 'signaluser', avatar_platform: 'twitter')
    assert user.play_signal.present? && !user.play_signal.published
    assert user.play_signal.message == ''
  end

  test '.create_with_omniauth creates User' do
    hash = {
      provider: 'twitter',
      uid: 'testuid',
      info: {
        nickname: 'testname',
        image_url: '',
      },
    }
    user = User.create_with_omniauth(hash)
    assert user.present?
  end

  test '.create_with_omniauth creates User with non-duplicate username' do
    User.create(username: 'testname', avatar_platform: 'discord')
    hash = {
      provider: 'twitter',
      uid: 'testuid',
      info: {
        nickname: 'testname',
        image_url: '',
      },
    }
    user = User.create_with_omniauth(hash)
    assert user.username == 'testname1'
  end
end
