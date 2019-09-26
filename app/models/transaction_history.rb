class TransactionHistory < ApplicationRecord
  belongs_to :by_user, :class_name => "User"
  belongs_to :transaction_type
  belongs_to :account_from, :class_name => "BankAccount", optional: true
  belongs_to :account_to, :class_name => "BankAccount"

end
