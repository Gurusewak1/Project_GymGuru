class TaxRate < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst", "hst", "id", "id_value", "province", "pst", "updated_at"]
  end
  
end
