ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :current_sign_in_at
      row :sign_in_count
      row :created_at

      # List of customers and their orders
      row "Customers and Orders" do
        User.all.map do |user|
          div do
            h5 "Customer: #{user.email}"
            ul do
              user.orders.each do |order|
                li "Order ID: #{order.id}"
                ul do
                  li "Subtotal: #{number_to_currency(order.subtotal)}"
                  li "GST: #{number_to_currency(order.gst)}"
                  li "PST: #{number_to_currency(order.pst)}"
                  li "HST: #{number_to_currency(order.hst)}"
                  li "QST: #{number_to_currency(order.qst)}"
                  li "Total: #{number_to_currency(order.total)}"
                  li "Status: #{order.status}"
                  li "Products: " do
                    ul do
                      order.order_items.each do |item|
                        li "#{item.product_name} - Quantity: #{item.quantity}"
                      end
                    end
                  end
                end
              end
            end
          end
        end.join.html_safe
      end
    end
    active_admin_comments
  end
end
