class Mutations::UpdateSignal < Mutations::BaseMutation
  argument :message, String, required: true
  argument :end_time, String, required: true
  argument :lat, Float, required: true
  argument :lng, Float, required: true
  argument :published, Boolean, required: true

  field :errors, [String], null: false

  def resolve(message:, end_time:, lat:, lng:, published:)
    return unauthorized_hash if context[:current_user].nil?

    signal = context[:current_user].play_signal
    signal.message = message
    signal.end_time = DateTime.parse(end_time)
    signal.lat = lat
    signal.lng = lng
    signal.published = published

    if signal.save
      { errors: [] }
    else
      { errors: signal.errors.full_messages }
    end
  end
end
