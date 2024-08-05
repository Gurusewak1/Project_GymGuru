ActiveAdmin.register User do
  # Permit parameters for strong parameters
  permit_params :email, :password, :password_confirmation, :admin, :address, :province, :name

  # Form for creating and editing users
  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :address
      f.input :province
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  # Index page configuration
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :address
    column :province
    column :created_at
    column :updated_at
    actions
  end

  filter :email
  filter :name
  filter :address
  filter :province
  filter :created_at
  filter :updated_at


  show do
    attributes_table do
      row :name
      row :email
      row :address
      row :province
      row :created_at
      row :updated_at
    end
    
    panel "Order Details" do
      table_for user.orders.flat_map(&:order_items) do
        column "Order ID" do |order_item|
          order_item.order.id
        end
        column "Product Name", :product_name
        column "Quantity", :quantity
        column "Price" do |order_item|
          number_to_currency(order_item.price)
        end
        column "Total without Taxes" do |order_item|
          number_to_currency(order_item.quantity * order_item.price)
        end
      
      end
    end

    panel "Orders" do
      table_for user.orders do
        column "Order ID", :id
        column "Subtotal" do |order|
          number_to_currency(order.subtotal)
        end
        column "GST" do |order|
          number_to_currency(order.gst)
        end
        column "PST" do |order|
          number_to_currency(order.pst)
        end
        column "HST" do |order|
          number_to_currency(order.hst)
        end
        column "QST" do |order|
          number_to_currency(order.qst)
        end
        column "Total with Taxes" do |order|
          subtotal = order.subtotal
          gst = order.gst
          pst = order.pst
          hst = order.hst
          qst = order.qst
          total_with_taxes = subtotal + gst + pst + hst + qst
          number_to_currency(total_with_taxes)
        end
        column "Status", :status
      end
    end

     
    
  end
end
