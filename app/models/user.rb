class User < ApplicationRecord
  # Associations
  has_one :cart
  has_many :orders, dependent: :destroy
  belongs_to :province, optional: true  
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :email, presence: true, uniqueness: true


  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at email encrypted_password id name remember_created_at reset_password_sent_at reset_password_token updated_at username address province_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[cart orders province]
  end
end
