class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  def calculate_total
    # Calculate total based on other attributes
    self.total = subtotal + gst + hst + pst
  end

end
