class CreateBankBranches < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_branches do |t|
      t.references :bank, foreign_key: true
      t.references :location, foreign_key: true
      t.string :address

      t.timestamps
    end
  end
end
