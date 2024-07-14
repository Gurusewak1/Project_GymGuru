# app/controllers/checkout_controller.rb

class CheckoutController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)
    @subtotal = calculate_subtotal(@products, @cart)
    @taxes = calculate_taxes(@subtotal)
    @total = @subtotal + @taxes
    @provinces = Province.order(:name).pluck(:name)

    # Fetch tax rates based on user's selected province
    @tax_rate = TaxRate.find_by(province: current_user.province)

    # Calculate taxes based on tax rates
    @taxes_gst = @tax_rate ? @subtotal * (@tax_rate.gst / 100.0) : 0
    @taxes_pst = @tax_rate ? @subtotal * (@tax_rate.pst / 100.0) : 0
    @taxes_hst = @tax_rate ? @subtotal * (@tax_rate.hst / 100.0) : 0

    # Prepare line items for Stripe session
    line_items = @products.map do |product|
      {
        price_data: {
          currency: 'usd',
          product_data: {
            name: product.name
            # Add other fields as needed, such as description, images, etc.
          },
          unit_amount: (product.price * 100).to_i, # Stripe requires amount in cents
        },
        quantity: @cart[product.id.to_s].to_i,
      }
    end

    # Create a new Stripe session
    @stripe_session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment', # Specify mode at the session level
      success_url: checkout_success_checkout_index_url, 
      cancel_url: checkout_cancel_checkout_index_url

    })
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
      status: 'pending',
      address: current_user.address,
      province: current_user.province
    )

    session[:cart] = nil
    redirect_to root_path, notice: "Order placed successfully!"
  end

  def create_payment
    # Create a PaymentIntent using Stripe Ruby gem
    begin
      payment_intent = Stripe::PaymentIntent.create({
        amount: (@total * 100).to_i,
        currency: 'usd',
        metadata: { integration_check: 'accept_a_payment' }
      })
  
      # Return client secret to front-end for Stripe.js
      render json: { client_secret: payment_intent.client_secret }
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  

  def success
    # Handle successful payment (update order status, send confirmation emails, etc.)
    flash[:notice] = "Payment was successful!"
    redirect_to root_path
  end

  def cancel
    # Handle cancelled payment
    flash[:alert] = "Payment was cancelled."
    redirect_to checkout_index_path
  end

  def update_province
    province_name = params[:province]
    province = Province.find_by(name: province_name)
  
    if province
      current_user.update(province: province.name)
      redirect_to checkout_index_path, notice: "Province updated successfully!"
    else
      redirect_to checkout_index_path, alert: "Province not found!"
    end
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
