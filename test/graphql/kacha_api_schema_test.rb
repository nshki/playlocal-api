class KachaApiSchemaTest < ActiveSupport::TestCase
  test 'activeSignals' do
    query = %(
      {
        activeSignals {
          message
          endTime
          lat
          lng
          published
          user {
            username
            avatarPlatform
            identities {
              provider
              uid
              username
              imageUrl
            }
          }
        }
      }
    )

    response = KachaApiSchema.execute(query, context: {}, variables: {}).to_h
    assert !response.has_key?('errors')
  end

  test 'updateSignal' do
    user = users(:tohfoo)
    end_time = DateTime.tomorrow
    query = %(
      mutation {
        updateSignal(message: "Test", endTime: "#{end_time.to_s}", published: true) {
          errors
        }
      }
    )
    context = { current_user: user }

    # Authorized?
    response = KachaApiSchema.execute(query, context: {}, variables: {}).to_h
    assert response['data']['updateSignal']['errors'].first == I18n.t('unauthorized')

    # Successful mutation.
    response = KachaApiSchema.execute(query, context: context, variables: {}).to_h
    signal = user.play_signal
    assert signal.message == 'Test'
    assert signal.end_time == end_time
    assert signal.published == true
  end
end
