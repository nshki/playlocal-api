require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    assert users(:tohfoo).valid?
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

  test 'has one signal' do
    user = users(:tohfoo)
    assert user.play_signal.class == PlaySignal
  end
end
