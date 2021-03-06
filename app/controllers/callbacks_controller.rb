class CallbacksController < ApplicationController
  def handle
    # Determine if this sign in was for an existing or new User.
    user = nil
    reassociated = false
    if auth_params.has_key?('token')
      args = Auth.decode(auth_params['token'])
      user = User.find_by(args)
    end

    # Find the Identity instance. Create new Identity if none was found.
    identity = Identity.find_with_omniauth(auth_hash)
    identity = Identity.create_with_omniauth(auth_hash, user) if identity.nil?

    # Reassociate Identity if User already existed. This should only trigger if
    # an Identity was found and the User instances didn't match.
    if user.present? && identity.user != user
      old_user = identity.user
      identity.update(user: user)
      old_user.destroy if old_user.identities.count == 0
      reassociated = true
    end

    if identity.user.present?
      jwt = Auth.encode(identity.user)
      if reassociated
        redirect_to "#{client_url}/profile?token=#{jwt}"
      else
        redirect_to "#{client_url}?token=#{jwt}"
      end
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
