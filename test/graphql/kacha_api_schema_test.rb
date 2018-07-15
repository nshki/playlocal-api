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
    query = %(
      mutation {
        updateSignal(message: "Test", endTime: "Jul 15, 2018 7:14pm", published: true) {
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
    assert signal.end_time == DateTime.new(2018, 7, 15, 19, 14)
    assert signal.published == true
  end

  test 'updateProfile' do
    user = users(:tohfoo)
    query = %(
      mutation {
        updateProfile(username: "Teehee", avatarPlatform: "discord") {
          errors
        }
      }
    )
    context = { current_user: user }

    # Authorized?
    response = KachaApiSchema.execute(query, context: {}, variables: {}).to_h
    assert response['data']['updateProfile']['errors'].first == I18n.t('unauthorized')

    # Successful mutation.
    response = KachaApiSchema.execute(query, context: context, variables: {}).to_h
    assert user.username == 'Teehee'
    assert user.avatar_platform == 'discord'
  end
end
