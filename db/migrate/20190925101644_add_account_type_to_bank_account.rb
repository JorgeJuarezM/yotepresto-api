class AddAccountTypeToBankAccount < ActiveRecord::Migration[5.1]
  def change
    add_reference :bank_accounts, :account_type, foreign_key: true
  end
end
