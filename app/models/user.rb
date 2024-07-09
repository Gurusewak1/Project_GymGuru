# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  
    # Validations
    validates :email, presence: true, uniqueness: true
    # Add more validations as needed
  
    # Associations
    # Example:
    # has_many :posts
  end
  