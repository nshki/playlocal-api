class RedirectController < ApplicationController
  def redirect_to_client_site
    redirect_to ENV['CLIENT_URL']
  end
end
