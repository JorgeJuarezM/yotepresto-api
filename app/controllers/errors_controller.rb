class ErrorsController < ApplicationController
  def err_404
    raise ActionController::RoutingError.new(params[:path])
  end
end
