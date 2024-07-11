class Product < ApplicationRecord
    belongs_to :category
    has_one_attached :image

    scope :stock_eq, ->(stock) { where(stock: stock) }

  validates :name, :description, :price, :stock, :category_id, presence: true
  validates :price, :stock, numericality: true

  def discounted_price
    if on_sale.present? && on_sale > 0
      price - (price * on_sale / 100.0)
    else
      price
    end
  end

    def self.ransackable_attributes(auth_object = nil)
        ["category", "created_at", "description", "id", "id_value", "name", "price", "updated_at"]
      end

      def self.ransackable_associations(auth_object = nil)
        ["category"]
      end
      def self.ransackable_attributes(auth_object = nil)
        super + %w(stock) # Add stock to ransackable attributes
      end

end
