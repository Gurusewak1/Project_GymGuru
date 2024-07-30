class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_name, :quantity, :price, presence: true


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "order_id", "price", "product", "product_id", "product_name", "quantity", "updated_at"]
  end
end
