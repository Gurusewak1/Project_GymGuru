class OrderItemsController < ApplicationController
# Example from OrdersController
def show
  @order = Order.find_by(id: params[:id])
  unless @order
    # Handle case where order with given id does not exist
    redirect_to root_path, alert: "Order not found"
    return
  end
  @order_items = @order.order_items.includes(:product)
end

  
end
