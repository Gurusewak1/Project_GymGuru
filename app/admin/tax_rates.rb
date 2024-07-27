# app/admin/tax_rates.rb
ActiveAdmin.register TaxRate do
  permit_params :province_id, :gst, :hst, :pst, :qst

  index do
    selectable_column
    id_column
    column :province
    column :gst
    column :hst
    column :pst
    column :qst
    actions
  end

  form do |f|
    f.inputs do
      f.input :province, as: :select, collection: Province.all.collect { |p| [p.name, p.id] }, include_blank: false
      f.input :gst
      f.input :hst
      f.input :pst
      f.input :qst
    end
    f.actions
  end

  filter :province
end
