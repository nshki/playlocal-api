class Mutations::DisconnectAccount < Mutations::BaseMutation
  argument :provider, String, required: true

  field :avatar_platform, String, null: true
  field :errors, [String], null: false

  def resolve(provider:)
    return unauthorized_hash if context[:current_user].nil?

    user = context[:current_user]

    # Find and remove the associated Identity by provider.
    identity = user.identities.find_by(provider: provider)
    if identity.present?
      identity.destroy
    else
      return { avatar_platform: nil, errors: ['Account not found'] }
    end

    # Destroy the User if there are no Identities left. Patch up the avatar
    # platform otherwise.
    if user.identities.count == 0
      user.destroy
      return { avatar_platform: nil, errors: [] }
    elsif user.identities.find_by(provider: user.avatar_platform).nil?
      user.update(avatar_platform: user.identities.first.provider)
      return { avatar_platform: user.reload.avatar_platform, errors: [] }
    else
      return { avatar_platform: nil, errors: [] }
    end
  end
end
