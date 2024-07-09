# app/models/user.rb
class User < ApplicationRecord
    # Devise modules
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable
  
    # Ransackable attributes for searching
    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "email", "encrypted_password", "id", "id_value", "name", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at", "username"]
    end
  
    # Validations
    validates :email, presence: true, uniqueness: true
    # Add more validations as needed
  
    # Associations
    # Example:
    # has_many :posts
  end
  