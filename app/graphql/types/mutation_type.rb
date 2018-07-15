class Types::MutationType < Types::BaseObject
  field :update_signal, mutation: Mutations::UpdateSignal
  field :update_profile, mutation: Mutations::UpdateProfile
end
