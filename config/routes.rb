Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'callbacks#handle'
end
