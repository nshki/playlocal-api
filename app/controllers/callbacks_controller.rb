class CallbacksController < ApplicationController
  def handle
    # Determine if this sign in was for an existing or new User.
    user = nil
    if auth_params.has_key?('token')
      args = Auth.decode(auth_params['token'])
      user = User.find_by(args)
    end

    # Find/create the Identity instance. This step will ensure the Identity has
    # a corresponding User.
    identity = Identity.find_with_omniauth(auth_hash)
    identity = Identity.create_with_omniauth(auth_hash, user) if identity.nil?

    if identity.user.present?
      jwt = Auth.encode(identity.user)
      redirect_to "#{client_url}?token=#{jwt}"
    else
      # This shouldn't occur at all, but is there as a fallback in case this
      # somehow happens. This will likely trigger due to tinkering from client.
      redirect_to client_url
    end
  end

  protected

    def auth_hash
      request.env['omniauth.auth']
    end

    def auth_params
      request.env['omniauth.params']
    end

    def client_url
      ENV['CLIENT_URL']
    end
end
