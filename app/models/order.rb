class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items
  belongs_to :province


  def calculate_total
    # Calculate total based on other attributes
    self.total = subtotal + gst + hst + pst
  end
  validates :address, :province, :total, presence: true

end
