class Types::IdentityType < Types::BaseObject
  field :provider, String, null: true
  field :uid, String, null: true
  field :username, String, null: true
  field :image_url, String, null: true
  field :user, Types::UserType, null: true
end
