class TaxRate < ApplicationRecord
  belongs_to :province, foreign_key: :province, primary_key: :name

  validates :province, presence: true


  def self.ransackable_associations(auth_object = nil)
    ["province"]
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst", "hst", "id", "id_value", "province", "pst", "updated_at"]
  end
  
end
