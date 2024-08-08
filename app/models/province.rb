class Province < ApplicationRecord
  has_many :users
  has_many :orders
  has_many :tax_rates, foreign_key: :province, primary_key: :name

  validates :name, presence: true
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at"]
  end
end
