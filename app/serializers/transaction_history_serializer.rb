class TransactionHistorySerializer < ActiveModel::Serializer
  attributes :amount
  has_one :transaction_type
  has_one :account_from
  has_one :account_to
end
