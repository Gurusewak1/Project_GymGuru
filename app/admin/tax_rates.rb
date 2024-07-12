# app/admin/tax_rates.rb
ActiveAdmin.register TaxRate do
  permit_params :province, :gst, :hst, :pst

  index do
    selectable_column
    id_column
    column :province
    column :gst
    column :hst
    column :pst
    actions
  end

  form do |f|
    f.inputs do
      f.input :province
      f.input :gst
      f.input :hst
      f.input :pst
    end
    f.actions
  end

  filter :province
end
