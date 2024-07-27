class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      redirect_to @order, notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  def index
    @orders = current_user.orders.includes(:order_items)
  end

# orders_controller.rb
def show
  @order = Order.find(params[:id])
  @order_items = @order.order_items.includes(:product) # Ensure product is eager loaded
end

  private

  def order_params
    params.require(:order).permit(:total_amount, :status, :address, :province)
  end
end
