class CheckoutController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:create_payment]

  def index
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)
    @subtotal = calculate_subtotal(@products, @cart)
    @provinces = Province.order(:name).pluck(:name, :id)
    @province_name = current_user.province ? Province.find_by(id: current_user.province).name : ""

    @tax_rate = TaxRate.find_by(province: current_user.province)
    @taxes_gst = @tax_rate ? @subtotal * (@tax_rate.gst / 100.0) : 0
    @taxes_pst = @tax_rate ? @subtotal * (@tax_rate.pst / 100.0) : 0
    @taxes_hst = @tax_rate ? @subtotal * (@tax_rate.hst / 100.0) : 0
    @taxes_qst = @tax_rate ? @subtotal * (@tax_rate.qst / 100.0) : 0
    @total = @subtotal + @taxes_gst + @taxes_pst + @taxes_hst + @taxes_qst

    line_items = @products.map do |product|
      {
        price_data: {
          currency:     "usd",
          product_data: {
            name: product.name
          },
          unit_amount:  (product.price * 100).to_i
        },
        quantity:   @cart[product.id.to_s].to_i
      }
    end

    @stripe_session = Stripe::Checkout::Session.create({
                                                         payment_method_types: ["card"],
                                                         line_items:,
                                                         mode:                 "payment",
                                                         success_url:          checkout_success_checkout_index_url,
                                                         cancel_url:           checkout_cancel_checkout_index_url
                                                       })
  end

  def create_order
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)

    # Debugging information
    Rails.logger.debug "Cart: #{@cart.inspect}"
    Rails.logger.debug "Products: #{@products.inspect}"

    @subtotal = calculate_subtotal(@products, @cart)
    @tax_rate = TaxRate.find_by(province: current_user.province)
    @taxes_gst = @tax_rate ? @subtotal * (@tax_rate.gst / 100.0) : 0
    @taxes_pst = @tax_rate ? @subtotal * (@tax_rate.pst / 100.0) : 0
    @taxes_hst = @tax_rate ? @subtotal * (@tax_rate.hst / 100.0) : 0
    @taxes_qst = @tax_rate ? @subtotal * (@tax_rate.qst / 100.0) : 0
    @total = @subtotal + @taxes_gst + @taxes_pst + @taxes_hst + @taxes_qst

    order = current_user.orders.create(
      subtotal: @subtotal,
      gst:      @taxes_gst,
      pst:      @taxes_pst,
      hst:      @taxes_hst,
      qst:      @taxes_qst,
      total:    @total,
      status:   "pending",
      address:  current_user.address,
      province: current_user.province
    )

    Rails.logger.debug "Created Order: #{order.inspect}"

    @products.each do |product|
      order.order_items.create(
        product_name: product.name,
        product_id:   product.id,
        quantity:     @cart[product.id.to_s].to_i,
        price:        product.price
      )

      # Debugging each order item
      Rails.logger.debug "Created OrderItem: #{order.order_items.last.inspect}"
    end

    session[:cart] = nil
    redirect_to root_path, notice: "Order placed successfully!"
  end

  def create_payment
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)
    @subtotal = calculate_subtotal(@products, @cart)
    @tax_rate = TaxRate.find_by(province: current_user.province)
    @taxes_gst = @tax_rate ? @subtotal * (@tax_rate.gst / 100.0) : 0
    @taxes_pst = @tax_rate ? @subtotal * (@tax_rate.pst / 100.0) : 0
    @taxes_hst = @tax_rate ? @subtotal * (@tax_rate.hst / 100.0) : 0
    @taxes_qst = @tax_rate ? @subtotal * (@tax_rate.qst / 100.0) : 0
    @total = @subtotal + @taxes_gst + @taxes_pst + @taxes_hst + @taxes_qst

    begin
      payment_intent = Stripe::PaymentIntent.create({
                                                      amount:   (@total * 100).to_i,
                                                      currency: "usd",
                                                      metadata: { integration_check: "accept_a_payment" }
                                                    })

      order = current_user.orders.create(
        subtotal:                 @subtotal,
        gst:                      @taxes_gst,
        pst:                      @taxes_pst,
        hst:                      @taxes_hst,
        qst:                      @taxes_qst,
        total:                    @total,
        status:                   "paid",
        address:                  current_user.address,
        province:                 current_user.province,
        stripe_payment_intent_id: payment_intent.id # Save the payment intent ID
      )

      @products.each do |product|
        order.order_items.create(
          product_name: product.name,
          product_id:   product.id,
          quantity:     @cart[product.id.to_s].to_i,
          price:        product.price
        )
      end

      # Mark the order as paid here if necessary
      order.update(status: "paid")

      session[:cart] = nil
      render json: { message: "Payment processed successfully!", order_id: order.id }, status: :ok
    rescue Stripe::StripeError => e
      render json: { message: "Stripe error: #{e.message}" }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { message: "Unknown error: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def success
    flash[:notice] = "Payment was successful!"
    redirect_to root_path
  end

  def cancel
    flash[:alert] = "Payment was cancelled."
    redirect_to checkout_index_path
  end

  def update_province
    province_id = params[:province]
    province = Province.find_by(id: province_id)

    if province
      current_user.update(province:)
      redirect_to checkout_index_path, notice: "Province updated successfully!"
    else
      redirect_to checkout_index_path, alert: "Province not found!"
    end
  end

  private

  def calculate_subtotal(products, cart)
    products.sum { |product| product.price * cart[product.id.to_s].to_i }
  end
end
