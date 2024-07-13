class CheckoutController < ApplicationController
  before_action :authenticate_user!


  require 'paypal-sdk-rest'


  def index
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)
    @subtotal = calculate_subtotal(@products, @cart)
    @taxes = calculate_taxes(@subtotal)
    @total = @subtotal + @taxes
    @provinces = Province.pluck(:name).uniq.sort
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

  def create_payment
    @cart = session[:cart] || {}
    @subtotal = calculate_subtotal(Product.where(id: @cart.keys), @cart)
    @taxes = calculate_taxes(@subtotal)
    
    @subtotal ||= 0
    @taxes ||= 0
    @total = @subtotal + @taxes

    PayPal::SDK.configure(
      mode: "sandbox",
      client_id: ENV['AX5spIPe7_5RjCIKQW17oZ5GFC78Ji7mSYDv7-wJd7VISXmCDGsxymkoXXHL_vbLa5_Q9gkSrOOWkhUN'],
      client_secret: ENV['EIwQr3UD7j4ZMt4u1BGxgi6zv8FolU1U96rB0SQJ8Ucu23B4D3n5kiFQUJp1c6NpExrGw0566fsaHZFs'],
      ssl_options: { ca_file: '/etc/ssl/certs/ca-certificates.crt' }
      )
    
    
    payment = PayPal::SDK::REST::Payment.new({
      intent: 'sale',
      payer: {
        payment_method: 'paypal'
      },
      redirect_urls: {
        return_url: checkout_success_url,
        cancel_url: checkout_cancel_url
      },
      transactions: [{
        amount: {
          total: '%.2f' % @total,
          currency: 'USD' # Adjust currency as needed
        },
        description: 'Your purchase description'
      }]
    })

    if payment.create
      redirect_to payment.links.find { |link| link.method == 'REDIRECT' }.href
    else
      flash[:error] = "Failed to create PayPal payment: #{payment.error}"
      redirect_to checkout_index_path
    end
  end

  def success
    # Handle successful payment
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
    current_user.update(province: province.name)  # Ensure you're saving the province name
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
