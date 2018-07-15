class Mutations::UpdateProfile < Mutations::BaseMutation
  argument :username, String, required: true
  argument :avatar_platform, String, required: true

  field :errors, [String], null: false

  def resolve(username:, avatar_platform:)
    return unauthorized_hash if context[:current_user].nil?

    user = context[:current_user]
    user.username = username
    user.avatar_platform = avatar_platform

    if user.save
      { errors: [] }
    else
      { errors: signal.errors.full_messages }
    end
  end
end
