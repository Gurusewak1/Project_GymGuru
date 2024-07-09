class UpdateUsersForDevise < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :password
    # You don't need to add encrypted_password here since it already exists
    # Add any other columns you need to update for Devise
  end
end
