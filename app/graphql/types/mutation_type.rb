class Types::MutationType < Types::BaseObject
  field :update_signal, mutation: Mutations::UpdateSignal
  field :update_profile, mutation: Mutations::UpdateProfile
  field :disconnect_account, mutation: Mutations::DisconnectAccount
end
