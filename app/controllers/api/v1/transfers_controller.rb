class Api::V1::TransfersController < ApplicationController
  before_action :authorize_set_user

  def index
    begin
      acc = BankAccount.find_by(user_id: @current_user.id)
      trs = TransactionHistory.where('account_to_id = ? OR account_from_id = ?', acc.id, acc.id)
      if trs.nil?
        render json: {message: "Invalid model", errors: "Do not have a bank account" }, status: :unprocessable_entity
      else
        render json: trs, status: :ok
      end
    rescue
      render json: {message: "Invalid model", errors: "Do not have a bank account" }, status: :unprocessable_entity
    end
  end

  def all
    if @current_user.is_admin?
      render json: TransactionHistory.all, status: :ok
    else
      render json: {message: "Denied. Do not have administrator permits", errors: ""}, status: :unauthorized
    end
  end

  def deposit
    if @current_user.can_make_deposit?
      transaction "Deposit"
      else
      render json: {message: "Denied. Do not have permits", errors: ""}, status: :unauthorized
    end
  end

  def transfer
    if @current_user.can_make_transfer?
      transaction "Transfer"
    else
      render json: {message: "Denied. Do not have permits", errors: ""}, status: :unauthorized
    end
  end

  def withdraw
    if @current_user.can_make_withdraw?
      transaction "Withdraw"
    else
      render json: {message: "Denied. Do not have permits", errors: ""}, status: :unauthorized
    end
  end

  private
  def data_params
    params.permit(:amount, :code)
  end

  def transaction type
    if !(true if Float(data_params[:amount]) rescue false)
      render json: {message: "Invalid model", errors: "Amount error. It's not a number" }, status: :unprocessable_entity
    elsif  data_params[:amount].to_d > 0
        if type == "Transfer" || type  == "Deposit"
          acc = BankAccount.find_by_clabe(data_params[:code])
          render json: {message: "Invalid model", errors: "Code error." }, status: :unprocessable_entity if acc.nil?
        else
          acc = BankAccount.find_by(user_id: @current_user.id)
          render json: {message: "Invalid model", errors: "Do not have a bank account." }, status: :unprocessable_entity if acc.nil?
        end

        if !acc.nil?
          begin
            th = TransactionHistory.new amount: data_params[:amount]
            th.by_user = @current_user
            th.account_to = acc
            th.transaction_type = TransactionType.find_by_name(type)
            case type
            when "Transfer"
              if !@current_user.bank_accounts.nil?
                if @current_user.bank_accounts.count == 0
                  render json: {message: "Invalid model", errors: "Do not have a bank account." }, status: :unprocessable_entity
                else
                  acc_from  = @current_user.bank_accounts.first
                  if data_params[:amount].to_d <= acc_from.balance
                    th.account_from = acc_from
                    if th.save!
                      acc_from.update({balance: acc_from.balance - data_params[:amount].to_d })
                      acc.update({balance: acc.balance + data_params[:amount].to_d })
                    end
                    render json: {message:"Successful transaction.", errors: ""}, status: :ok
                  else
                    render json: {message: "Invalid model", errors: "Insufficient funds." }, status: :unprocessable_entity
                  end
                end
              end
            when "Deposit"
              if th.save!
                acc.update({balance: acc.balance + data_params[:amount].to_d })
              end
              render json: {message:"Successful transaction.", errors: ""}, status: :ok
            when "Withdraw"
              if data_params[:amount].to_d <= acc.balance
                if th.save!
                  acc.update({balance: acc.balance - data_params[:amount].to_d })
                end
                render json: {message:"Successful transaction.", errors: ""}, status: :ok
              else
                render json: {message: "Invalid model", errors: "Insufficient funds." }, status: :unprocessable_entity
              end
            end



          rescue ActiveRecord::RecordInvalid => e
            render json: {message: "Invalid model", errors: th.errors.full_messages }, status: :unprocessable_entity
          rescue ActiveRecord::RecordNotSaved => e
            render json: {message: "Invalid model", errors: th.errors.full_messages }, status: :unprocessable_entity
          end
        end

      else
        render json: {message: "Invalid model", errors: "Amount must be greater than zero" }, status: :unprocessable_entity
    end

  end


end
