class Mutations::UpdateSignal < Mutations::BaseMutation
  argument :message, String, required: true
  argument :end_time, String, required: true
  argument :published, Boolean, required: true

  field :errors, [String], null: false

  def resolve(message:, end_time:, published:)
    return unauthorized_hash if context[:current_user].nil?

    signal = context[:current_user].play_signal
    signal.message = message
    signal.end_time = end_time
    signal.published = published

    if signal.save
      { errors: [] }
    else
      { errors: signal.errors.full_messages }
    end
  end
end
