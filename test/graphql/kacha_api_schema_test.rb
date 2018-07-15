class KachaApiSchemaTest < ActiveSupport::TestCase
  test 'full, valid query' do
    query_string = %(
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

    response = KachaApiSchema.execute(query_string, context: {}, variables: {})
    response_hash = response.to_h
    assert !response_hash.has_key?('errors')
  end
end
