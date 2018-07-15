class CallbacksController < ApplicationController
  def handle
    uid_key = "#{auth_hash[:provider]}_uid"
    username_key = "#{auth_hash[:provider]}_username"
    image_url_key = "#{auth_hash[:provider]}_image_url"
    args = { uid_key => auth_hash[:uid] }

    user = User.find_or_create_by(args) do |u|
      u.username = auth_hash[:info][:nickname]
      u[uid_key] = auth_hash[:uid]
      u[username_key] = auth_hash[:info][:nickname]
      u[image_url_key] = auth_hash[:info][:image]
    end

    if user
      jwt = Auth.encode(user, auth_hash[:provider])
      redirect_to "#{ENV['CLIENT_URL']}?token=#{jwt}"
    end
  end

  protected

    def auth_hash
      request.env['omniauth.auth']
    end
end
