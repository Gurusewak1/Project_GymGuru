class CartsController < ApplicationController
  def show
    @cart = session[:cart] || {}
  end

  def add
    product_id = params[:product_id]
    @cart = session[:cart] ||= {}
    @cart[product_id] ||= 0
    @cart[product_id] += 1
    redirect_to cart_path
  end

  def remove
    product_id = params[:product_id]
    @cart = session[:cart] ||= {}
    @cart[product_id] -= 1
    @cart.delete(product_id) if @cart[product_id] <= 0
    redirect_to cart_path
  end

  def update
    product_id = params[:product_id]
    quantity = params[:quantity].to_i
    @cart = session[:cart] ||= {}
    if quantity > 0
      @cart[product_id] = quantity
    else
      @cart.delete(product_id)
    end
    redirect_to cart_path
  end
end