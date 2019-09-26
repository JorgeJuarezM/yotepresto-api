class AddBalanceToBankAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :bank_accounts, :balance, :decimal
  end
end
