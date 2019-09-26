class Api::V1::AccountController < ApplicationController
  before_action :authorize_set_user, except: :login


  def login
    auth = Authentication.new data_params
    if auth.authenticate
      render json: { token: auth.token, exp: (Time.now + 12.hours.to_i).strftime("%m-%d-%Y %H:%M")}, status: :ok
    else
      render json: { error: 'Access Denied. Unauthorized' }, status: :unauthorized
    end
  end

  def data_params
    params.permit(:username, :password)
  end

end
