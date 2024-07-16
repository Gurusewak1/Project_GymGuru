class AddAddressAndProvinceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :address, :string
    add_reference :orders, :province, null: false, foreign_key: true
  end
end
