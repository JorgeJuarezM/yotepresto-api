class Api::V1::UserController < ApplicationController
  before_action :authorize_set_user

  def index
    render json: @current_user, status: :ok
  end

  def all
    if @current_user.is_admin?
      @users = User.all
      render json: @users, status: :ok
    else
      render json: {message: "Denied. Do not have administrator permits", errors: ""}, status: :unauthorized
    end
  end


  def new_holder
    new_user "holder"
  end

  def new_admin
    new_user "admin"
  end

  #def update
  #  update_user
  #end


  private
  def user_params
    params.permit(:username, :password, :email, :name, :last_name)
  end

  def new_user (role)
    if @current_user.can_create_users?
      user = User.create user_params
      begin
        if user.save!
          case role
          when "admin"
            user.add_role :admin
          when "holder"
            user.add_role :holder
            begin
              bank = BankAccount.build_bank_account ({ user: user})
              bank.generate_account_number
              bank.generate_clabe
              bank.save!
            end
          else
            user.add_role :holder
          end
          render json: {message:"User added.", errors: ""}, status: :ok
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: {message: "Invalid model", errors: user.errors.full_messages }, status: :unprocessable_entity
      rescue ActiveRecord::RecordNotSaved => e
        render json: {message: "Invalid model", errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: {message: "Denied. Do not have administrator permits", errors: ""}, status: :unauthorized
    end
  end

  def  update_user
    if @current_user.can_update_users?
      @user = User.find(params[:id])
      if  @user.update(user_params)
        render json: {message:"User updated.", errors: ""}, status: :ok
      else
        render json: {message: "Unable to update user", errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: {message: "Denied. Do not have administrator permits", errors: ""}, status: :unauthorized
    end
  end

end
