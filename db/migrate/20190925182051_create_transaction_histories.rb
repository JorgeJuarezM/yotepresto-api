class CreateTransactionHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :transaction_histories do |t|
      t.references :by_user
      t.references :transaction_type, foreign_key: true
      t.decimal :amount
      t.references :account_from
      t.references :account_to

      t.timestamps
    end

    add_foreign_key :transaction_histories, :users, column: :by_user_id, primary_key: :id
    add_foreign_key :transaction_histories, :bank_accounts, column: :account_from_id, primary_key: :id
    add_foreign_key :transaction_histories, :bank_accounts, column: :account_to_id, primary_key: :id
  end
end
