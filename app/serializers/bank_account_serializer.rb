class BankAccountSerializer < ActiveModel::Serializer
  attributes :clabe
  has_one :account_type
  has_one :user
end
