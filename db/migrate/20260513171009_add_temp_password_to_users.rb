class AddTempPasswordToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :temp_password, :string
    add_column :users, :temp_password_sent_at, :datetime
  end
end
