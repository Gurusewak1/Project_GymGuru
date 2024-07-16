class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_name, :quantity, :price, presence: true

end
