class Types::UserType < Types::BaseObject
  field :username, String, null: true
  field :avatar_platform, String, null: true
  field :twitter_uid, String, null: true
  field :twitter_username, String, null: true
  field :twitter_image_url, String, null: true
  field :discord_uid, String, null: true
  field :discord_username, String, null: true
  field :discord_image_url, String, null: true
  field :play_signal, Types::PlaySignalType, null: true
end
