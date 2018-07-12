class Types::QueryType < Types::BaseObject
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :active_signals, [Types::PlaySignalType], null: true do
    description 'Get all active signals'
  end

  def active_signals
    PlaySignal.all_active
  end
end
