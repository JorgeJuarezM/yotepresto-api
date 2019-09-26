class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :address
      t.references :municipality, foreign_key: true
      t.string :postal_code
      t.string :phone

      t.timestamps
    end
  end
end
