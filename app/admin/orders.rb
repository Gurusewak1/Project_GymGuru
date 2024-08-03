ActiveAdmin.register Order do
  permit_params :user_id, :province_id, :total_amount, :status, :address, :subtotal, :gst, :hst, :pst, :total, :qst

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :user_id, :total_amount, :status, :address, :province, :subtotal, :gst, :hst, :pst, :total, :province_id, :payment_id, :stripe_payment_intent_id, :qst
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :total_amount, :status, :address, :province, :subtotal, :gst, :hst, :pst, :total, :province_id, :payment_id, :stripe_payment_intent_id, :qst]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
