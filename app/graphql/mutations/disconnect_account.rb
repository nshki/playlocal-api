class Mutations::DisconnectAccount < Mutations::BaseMutation
  argument :provider, String, required: true

  field :errors, [String], null: false

  def resolve(provider:)
    return unauthorized_hash if context[:current_user].nil?

    user = context[:current_user]

    # Find and remove the associated Identity by provider.
    identity = user.identities.find_by(provider: provider)
    if identity.present?
      identity.destroy
    else
      return { errors: ['Account not found'] }
    end

    # Destroy the User if there are no Identities left.
    user.destroy if user.identities.count == 0
    { errors: [] }
  end
end
