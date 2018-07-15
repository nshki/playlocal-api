class Types::UserType < Types::BaseObject
  field :username, String, null: true
  field :avatar_platform, String, null: true
  field :identities, [Types::IdentityType], null:true
end
