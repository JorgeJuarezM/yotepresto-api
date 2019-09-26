class ApplicationController < ActionController::API


  protected
  def authorize_set_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JSONWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: "{}. Invalid token.", errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { message: "Denied. Invalid token.", errors: e.message }, status: :unauthorized
    rescue JWT::ExpiredSignature => e
      render json: { message: "Denied. Token has expired.", errors: e.message }, status: :unauthorized
    end
  end

  rescue_from ActionController::RoutingError do |e|
    logger.error 'Routing error occurred'
    render json: { message: "404 Not found", errors: e.message}, status: :not_found
  end

end
