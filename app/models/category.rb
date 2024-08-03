class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id name updated_at] # Using string array notation for consistency
  end

  def self.ransackable_associations(auth_object = nil)
    %w[products] # Using string array notation for consistency
  end
end
