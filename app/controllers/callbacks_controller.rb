class CallbacksController < ApplicationController
  def handle
    p request.env['omniauth.auth']
  end
end
