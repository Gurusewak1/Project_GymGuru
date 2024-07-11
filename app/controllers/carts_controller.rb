class CartsController < ApplicationController
  def show
    @cart = session[:cart] || {}
  end

  def add
    product_id = params[:product_id].to_s
    session[:cart] ||= {}
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += 1
    redirect_to cart_path, notice: 'Product added to cart.'
  end

  def remove
    product_id = params[:product_id].to_s
    session[:cart].delete(product_id)
    redirect_to cart_path, notice: 'Product removed from cart.'
  end

  def update
    product_id = params[:product_id].to_s
    session[:cart][product_id] = params[:quantity].to_i
    redirect_to cart_path, notice: 'Cart updated.'
  end
end
