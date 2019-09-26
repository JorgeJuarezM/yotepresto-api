class AddInformationToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_name, :string
    add_column :users, :dob, :datetime
    add_column :users, :id_card, :string
  end
end
