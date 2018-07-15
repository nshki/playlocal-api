class Mutations::BaseMutation < GraphQL::Schema::Mutation
  def unauthorized_hash
    { errors: [I18n.t('unauthorized')] }
  end
end
