class AddClabeToBankAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :bank_accounts, :clabe, :string
  end
end
