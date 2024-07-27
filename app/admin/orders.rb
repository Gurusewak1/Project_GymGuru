# app/admin/orders.rb
ActiveAdmin.register Order do
  # Permit parameters for strong parameters
  permit_params :status, :subtotal, :gst, :pst, :hst, :qst, :total, :user_id

# app/admin/orders.rb
form do |f|
  f.inputs "Order Details" do
    f.input :user
    f.input :subtotal
    f.input :gst
    f.input :pst
    f.input :hst
    f.input :qst
    f.input :total
    f.input :status, as: :select, collection: Order.statuses.keys.map { |status| [status.humanize, status] }
  end
  f.actions
end


 # app/admin/orders.rb
index do
  selectable_column
  id_column
  column :user
  column :subtotal
  column :gst
  column :pst
  column :hst
  column :qst
  column :total
  column :status do |order|
    status_tag(order.status.present? ? order.status.humanize : "No Status")
  end
  actions
end


  # Show page configuration
  show do
    attributes_table do
      row :user
      row :subtotal
      row :gst
      row :pst
      row :hst
      row :qst
      row :total
      row :status
      row :created_at
      row :updated_at
    end

    panel "Order Details" do
      table_for order.order_items do
        column "Product Name", :product_name
        column "Quantity", :quantity
        column "Price" do |order_item|
          number_to_currency(order_item.price)
        end
        column "Total" do |order_item|
          number_to_currency(order_item.quantity * order_item.price)
        end
      end
    end
  end
end
