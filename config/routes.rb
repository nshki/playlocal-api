Rails.application.routes.draw do
  root to: 'redirect#redirect_to_client_site'
  post '/graphql', to: 'graphql#execute'
  get '/auth/:provider/callback', to: 'callbacks#handle'

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end
end
