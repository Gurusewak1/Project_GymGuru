class AddSubtotalToOrders < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:orders, :subtotal)
      add_column :orders, :subtotal, :decimal
    end
  end
end