class BankAccount < ApplicationRecord
  belongs_to :user
  belongs_to :bank_branch
  belongs_to :account_type

  ACCOUNT_REGEX = /\A(^\d{11}$)/x
  CLABE_REGEX = /\A(^\d{18}$)/x
  validates :user_id, presence: true
  validates :bank_branch_id, presence: true
  validates :number, presence: true, format: { with: ACCOUNT_REGEX }
  validates :clabe, presence: true, format: { with: CLABE_REGEX }


  def self.build_bank_account(params)
    bank = BankAccount.new(params)
    bank.bank_branch = BankBranch.first if bank.bank_branch.nil?
    bank.opening_balance = 0.0 if bank.opening_balance.nil?
    bank.balance = bank.opening_balance
    bank.account_type = AccountType.find_by_name("Debit") if bank.account_type.nil?
    bank
  end

  def generate_account_number
    if !self.user.nil?
      account = ( (BankAccount.count + 1) % 100000000 ).to_s
      while account.length < 8
        account = "0" + account
      end
      if !self.bank_branch.nil?
        self.number =  self.bank_branch.location.code  + account
      end
    end
  end

  def generate_clabe
    if !self.bank_branch.nil?
      bank = self.bank_branch.bank
      location = self.bank_branch.location
      clabe = bank.abm + location.code + self.number
      arr_clabe = clabe.chars.to_a
      sum = 0
      arr_clabe.each do |p|
        weight = 0
        case p.to_i % 3
        when 0
            weight = 3
        when 1
          weight = 7
        when 2
          weight = 1
        end
        products = (p.to_i * weight)%10
        sum += products
      end

      self.clabe = clabe + "#{((10 - (sum%10))%10 )}"
    end
  end

end
