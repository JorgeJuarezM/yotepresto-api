class Api::V1::BankAccountController < ApplicationController
  before_action :authorize_set_user

  def all
    if @current_user.is_admin?
      render json: BankAccount.all, status: :ok
    else
      render json: {message: "Denied. Do not have administrator permits", errors: ""}, status: :unauthorized
    end
  end

  def index
      bank = BankAccount.find_by(user_id: @current_user.id)
      if bank.nil?
        render json: {message: "Invalid model", errors: "Do not have a bank account" }, status: :unprocessable_entity
      else
        render json: bank, status: :ok
      end

  end

  def balance_by_code
    begin
      if @current_user.is_admin?
        render json: {balance: BankAccount.find_by_clabe(data_params[:code]).balance}, status: :ok
      else
        render json: {message: "Denied. Do not have administrator permits", errors: ""}, status: :unauthorized
      end
    rescue
      render json: {message: "Invalid model", errors: "Code error." }, status: :unprocessable_entity
    end
  end

  def my_balance
    begin
      render json: {balance: BankAccount.find_by(user_id: @current_user.id).balance}, status: :ok
    rescue
      render json: {message: "Invalid model", errors: "Do not have a bank account" }, status: :unprocessable_entity
    end
  end

  private
  def data_params
    params.permit(:code)
  end

end
