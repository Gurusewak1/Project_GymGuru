class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)
    @subtotal = calculate_subtotal(@products, @cart)
    @taxes = calculate_taxes(@subtotal)
    @total = @subtotal + @taxes
    @provinces = TaxRate.pluck(:province).uniq.sort
    @tax_rate = TaxRate.find_by(province: current_user.province)
    @taxes_gst = @tax_rate ? @subtotal * (@tax_rate.gst / 100.0) : 0
    @taxes_pst = @tax_rate ? @subtotal * (@tax_rate.pst / 100.0) : 0
    @taxes_hst = @tax_rate ? @subtotal * (@tax_rate.hst / 100.0) : 0
  end

  def create_order
    @cart = session[:cart] || {}
    @subtotal = calculate_subtotal(Product.where(id: @cart.keys), @cart)
    @taxes = calculate_taxes(@subtotal)
    @total = @subtotal + @taxes
 
    order = current_user.orders.create(
      subtotal: @subtotal,
      taxes: @taxes,
      total: @total,
      status: 'pending', # Adjust as per your order status workflow
      address: current_user.address,
      province: current_user.province
    )
 
    session[:cart] = nil # Clear the cart after creating the order
 
    redirect_to root_path, notice: "Order placed successfully!"
  end

  def update_province
    province = params[:province]
    current_user.update(province: province)
    redirect_to checkout_index_path, notice: "Province updated successfully!"
  end

  private

  def calculate_subtotal(products, cart)
    products.sum { |product| product.price * cart[product.id.to_s].to_i }
  end

  def calculate_taxes(subtotal)
    tax_rate = TaxRate.find_by(province: current_user.province)
    return 0 unless tax_rate
 
    gst = subtotal * (tax_rate.gst / 100.0)
    pst = subtotal * (tax_rate.pst / 100.0)
    hst = subtotal * (tax_rate.hst / 100.0)
 
    gst + pst + hst
  end
end
