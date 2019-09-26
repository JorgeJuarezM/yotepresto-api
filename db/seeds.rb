# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = Role.new name: "Admin"
admin.save

holder = Role.new name: "Holder"
holder.save

debit_account = AccountType.new name: "Debit"
debit_account.save

deposit_trs = TransactionType.new name: "Deposit"
deposit_trs.save

transfer_trs = TransactionType.new name: "Transfer"
transfer_trs.save

withdraw_trs = TransactionType.new name: "Withdraw"
withdraw_trs.save

mex = Country.new name: "México", abbrv: "MEX", alfa_2: "MX", alfa_3: "MEX", numeric_code: 484
mex.save!

usa = Country.new name: "Estados Unidos de América", abbrv: "USA", alfa_2: "US", alfa_3: "USA", numeric_code: 840
usa.save!

bcn = State.new name: "Baja California", country_id: Country.find_by_alfa_3("MEX").id, code: "BCN"
bcn.save!

jal = State.new name: "Jalisco", country_id: Country.find_by_alfa_3("MEX").id, code: "JAL"
jal.save!

tj = Municipality.new name: "Tijuana", code: "001",  state_id: bcn.id, abbrv: "TJ"
tj.save!

gd = Municipality.new name: "Guadalajara", code: "039", state_id: jal.id, abbrv: "GD"
gd.save!

gdl = Location.new name: "Guadalajara", code: "320", abbrv: "GD"
gdl.municipality = Municipality.where(code: "039", state_id: State.find_by_code("JAL").id).first
gdl.save!

tjl = Location.new name: "Tijuana", code: "028", abbrv: "TJ"
tjl.municipality =  Municipality.where(code: "001", state_id: State.find_by_code("BCN").id ).first
tjl.save!

santander = Bank.new name: "Banco Santander, S.A.", abbrv: "SANTANDER", abm: "014", code: "BMSX"
santander.save!

test = Bank.new name: "Banco Online Test, S.A.", abbrv: "Test Bank", abm: "999", code: "BOTX"
test.save!


branch_1 = BankBranch.new bank_id: Bank.find_by_abm("999").id, location_id: Location.find_by_code("028").id
branch_1.save!

branch_2 = BankBranch.new bank_id: Bank.find_by_abm("999").id, location_id: Location.find_by_code("320").id
branch_2.save!

admin = User.new name:"Ever", username: "eever", email: "eever.matiias@gmail.com"
admin.password = "@cc0untYTP"
#admin.password_confirmation = "@cc0untYTP"
admin.save
admin.add_role :admin

