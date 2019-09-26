class CreateBankAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_accounts do |t|
      t.string :number
      t.decimal :opening_balance
      t.references :user, foreign_key: true
      t.references :bank_branch, foreign_key: true

      t.timestamps
    end
  end
end
