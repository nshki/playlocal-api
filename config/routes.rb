Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'
  get '/auth/:provider/callback', to: 'callbacks#handle'

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end
end
