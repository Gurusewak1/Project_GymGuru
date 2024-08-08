class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)

    @subtotal = @products.sum { |product| product.price * @cart[product.id.to_s].to_i }

    # Update user's province if selected from form
    current_user.update(province: params[:province]) if params[:province].present?

    @tax_rate = TaxRate.find_by(province: current_user.province)
    if @tax_rate
      @gst = @subtotal * (@tax_rate.gst / 100.0)
      @pst = @subtotal * (@tax_rate.pst / 100.0)
      @hst = @subtotal * (@tax_rate.hst / 100.0)
      @total = @subtotal + @gst + @pst + @hst
    else
      @gst = @pst = @hst = @total = 0
    end

    # Fetch provinces for dropdown
    @provinces = TaxRate.pluck(:province).uniq
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

  private

  def calculate_subtotal(products, cart)
    products.sum { |product| product.price * cart[product.id.to_s].to_i }
  end

  def calculate_taxes(subtotal, province)
    tax_rates = TaxRate.find_by(province:)
    if tax_rates
      {
        gst: subtotal * (tax_rates.gst / 100.0),
        pst: subtotal * (tax_rates.pst / 100.0),
        hst: subtotal * (tax_rates.hst / 100.0)
      }
    else
      { gst: 0, pst: 0, hst: 0 }
    end
  end
end
