class AddProductIdToOrderItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :order_items, :product,  foreign_key: true
  end
end
