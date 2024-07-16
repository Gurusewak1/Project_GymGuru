class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_amount
      t.string :status
      t.string :address
      t.string :province
      t.decimal :subtotal
      t.decimal :gst
      t.decimal :hst
      t.decimal :pst
      t.decimal :total

      t.timestamps
    end
  end
end
