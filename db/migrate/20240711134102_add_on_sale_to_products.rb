class AddOnSaleToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :on_sale, :integer
  end
end
