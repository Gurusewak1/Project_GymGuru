# app/models/user.rb
class User < ApplicationRecord
  has_one :cart
  has_many :orders, dependent: :destroy

  belongs_to :province, optional: true  # Make province optional

  
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Ransackable attributes for searching
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "id_value", "name", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at", "username", "address", "province"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["cart", "orders", "province"]
  end
  
  # Validations
  validates :email, presence: true, uniqueness: true
  # Add more validations as needed
  
  # Associations
  # Example:
  # has_many :posts
end
