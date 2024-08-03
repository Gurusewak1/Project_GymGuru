class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # Validations
  validates :quantity, :price, presence: true
  validates :product_name, presence: true, if: -> { product_name.present? }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id order_id price product_id product_name quantity updated_at]
  end
end
