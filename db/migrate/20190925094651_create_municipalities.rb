class CreateMunicipalities < ActiveRecord::Migration[5.1]
  def change
    create_table :municipalities do |t|
      t.string :name
      t.string :code
      t.string :abbrv
      t.references :state, foreign_key: true

      t.timestamps
    end
  end
end
