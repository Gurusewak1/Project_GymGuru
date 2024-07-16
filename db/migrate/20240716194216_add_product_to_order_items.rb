class AddProductToOrderItems < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :product, :string
  end
end
