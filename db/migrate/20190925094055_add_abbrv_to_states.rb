class AddAbbrvToStates < ActiveRecord::Migration[5.1]
  def change
    add_column :states, :abbrv, :string
  end
end
