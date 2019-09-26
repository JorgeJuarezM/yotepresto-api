class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :abbrv
      t.string :alfa_2
      t.string :alfa_3
      t.string :numeric_code

      t.timestamps
    end
  end
end
