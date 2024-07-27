class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items
  belongs_to :province
 
  # Define statuses as constants
  PENDING = 'pending'
  PAID = 'paid'
  SHIPPED = 'shipped'

  # Define a list of possible statuses
  STATUS_OPTIONS = [PENDING, PAID, SHIPPED]

  # Validations
  validates :status, inclusion: { in: STATUS_OPTIONS }

  def calculate_total
    # Calculate total based on other attributes
    self.total = subtotal + gst + hst + pst + qst
  end
  validates :address, :province, :total, presence: true


  def self.ransackable_associations(auth_object = nil)
    ["order_items", "products", "province", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["address", "created_at", "gst", "hst", "id", "id_value", "payment_id", "province", "province_id", "pst", "qst", "status", "stripe_payment_intent_id", "subtotal", "total", "total_amount", "updated_at", "user_id"]
  end

 
end
