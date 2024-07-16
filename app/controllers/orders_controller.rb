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

  def show
    @order = Order.find(params[:id])
    # Additional logic to display order details...
  end

  private

  def order_params
    params.require(:order).permit(:total_amount, :status, :address, :province)
  end
end
