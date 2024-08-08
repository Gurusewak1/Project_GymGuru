class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  belongs_to :province

  # Constants for order status
  PENDING = "pending"
  PAID = "paid"
  SHIPPED = "shipped"

  STATUS_OPTIONS = [PENDING, PAID, SHIPPED]

  # Validations
  validates :status, inclusion: { in: STATUS_OPTIONS }
  validates :address, :province, :total, presence: true

  # Method to provide status options for forms
  def self.status_options
    STATUS_OPTIONS.map { |status| [status.humanize, status] }
  end

  # Method to calculate total
  def calculate_total
    self.total = subtotal + gst + hst + pst + qst
  end

  # Ransack configuration
  def self.ransackable_associations(auth_object = nil)
    %w[order_items products province user]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[address created_at gst hst id payment_id province_id pst qst status stripe_payment_intent_id
       subtotal total updated_at user_id]
  end
end
