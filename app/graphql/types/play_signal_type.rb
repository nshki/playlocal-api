class Types::PlaySignalType < Types::BaseObject
  field :message, String, null: true
  field :end_time, String, null: true
  field :lat, Float, null: true
  field :lng, Float, null: true
  field :user, Types::UserType, null: true
  field :published, Boolean, null: true
end
