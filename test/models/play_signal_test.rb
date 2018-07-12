require 'test_helper'

class PlaySignalTest < ActiveSupport::TestCase
  test 'valid signal' do
    assert play_signals(:tohfoo_signal).valid?
  end

  test 'invalid without message' do
    signal = play_signals(:tohfoo_signal)
    signal.message = ''
    assert !signal.valid?
  end

  test 'invalid without lat' do
    signal = play_signals(:tohfoo_signal)
    signal.lat = nil
    assert !signal.valid?
  end

  test 'invalid without lng' do
    signal = play_signals(:tohfoo_signal)
    signal.lng = nil
    assert !signal.valid?
  end

  test '#active? based on end_time and published' do
    signal = play_signals(:tohfoo_signal)
    assert signal.active?

    signal.end_time = DateTime.yesterday
    assert !signal.active? && signal.valid?

    signal.end_time = DateTime.tomorrow
    signal.published = false
    assert !signal.active? && signal.valid?
  end

  test 'belongs to user' do
    signal = play_signals(:tohfoo_signal)
    assert signal.user.class == User
  end
end
