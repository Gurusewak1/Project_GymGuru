class AddProductIdToOrderItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :order_items, :product, foreign_key: true unless column_exists?(:order_items, :product_id)
  end
end