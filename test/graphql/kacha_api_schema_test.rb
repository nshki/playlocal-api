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
        updateSignal(message: "Test", endTime: "Jul 15, 2018 7:14pm", published: true, lat: 0, lng: 0) {
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

  test 'disconnectAccount' do
    user = User.create(username: 'testuser', avatar_platform: 'twitter')
    user_id = user.id
    user.identities.create(provider: 'twitter', uid: 'test', username: 'myaccount', image_url: '')
    user.identities.create(provider: 'discord', uid: 'test2', username: 'myaccount2', image_url: '')
    query1 = %(
      mutation {
        disconnectAccount(provider: "twitter") {
          avatarPlatform
          errors
        }
      }
    )
    query2 = %(
      mutation {
        disconnectAccount(provider: "discord") {
          avatarPlatform
          errors
        }
      }
    )
    context = { current_user: user }

    # Authorized?
    response = KachaApiSchema.execute(query1, context: {}, variables: {}).to_h
    assert response['data']['disconnectAccount']['errors'].first == I18n.t('unauthorized')

    # Successful mutations.
    response = KachaApiSchema.execute(query1, context: context, variables: {}).to_h
    assert user.identities.count == 1 && response['data']['disconnectAccount']['avatarPlatform'] == 'discord'
    response = KachaApiSchema.execute(query2, context: context, variables: {}).to_h
    assert User.find_by(id: user_id).nil?

    # Account doesn't exist error.
    response = KachaApiSchema.execute(query1, context: context, variables: {}).to_h
    assert response['data']['disconnectAccount']['errors'].first == 'Account not found'
  end
end
