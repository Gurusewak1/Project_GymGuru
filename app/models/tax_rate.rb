class TaxRate < ApplicationRecord
  belongs_to :province, primary_key: :id

  # Validations
  validates :province, presence: true

  # Ransack configuration
  def self.ransackable_associations(auth_object = nil)
    %w[province]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at gst hst id province_id pst updated_at]
  end
end
