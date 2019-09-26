class AddLocationCodeToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :location_code, :string
  end
end
