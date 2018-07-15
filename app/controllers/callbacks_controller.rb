class CallbacksController < ApplicationController
  def handle
    identity = Identity.find_with_omniauth(auth_hash)
    identity = Identity.create_with_omniauth(auth_hash) if identity.nil?

    if identity.user.present?
      jwt = Auth.encode(identity.user)
      redirect_to "#{client_url}?token=#{jwt}"
    else
      redirect_to client_url
    end
  end

  protected

    def auth_hash
      request.env['omniauth.auth']
    end

    def client_url
      ENV['CLIENT_URL']
    end
end
