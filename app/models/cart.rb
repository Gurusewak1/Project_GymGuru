# app/models/cart.rb
class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_product(product_id)
    # Find or create a new cart item associated with this cart and product
    cart_item = cart_items.find_or_initialize_by(product_id: product_id)
    
    # Initialize quantity to 0 if it's nil
    cart_item.quantity ||= 0
    
    # Increment quantity
    cart_item.quantity += 1
    
    # Save the cart item
    cart_item.save
    
    # Return the cart item in case it's needed
    cart_item
  end

  def update_quantity(product_id, quantity)
    cart_item = cart_items.find_by(product_id: product_id)
    cart_item.update(quantity: quantity) if cart_item
  end

  def remove_product(product_id)
    cart_items.find_by(product_id: product_id)&.destroy
  end


end
