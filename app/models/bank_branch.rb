class BankBranch < ApplicationRecord
  belongs_to :bank
  belongs_to :location

end
