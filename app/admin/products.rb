ActiveAdmin.register Product do
  filter :stock
  permit_params :name, :description, :price, :stock, :image, :category_id, :on_sale

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock
      f.input :on_sale
      f.input :image, as: :file
      f.input :category_id, as: :select, collection: Category.pluck(:name, :id)
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column :stock
    column :category
    column :on_sale
    column :image do |product|
      if product.image.attached?
        image_tag url_for(product.image), width: 50
      else
        "No image available"
      end
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :price
      row :stock
      row :category
      row :on_sale
      row :created_at
      row :updated_at
      row :image do |product|
        if product.image.attached?
          image_tag url_for(product.image)
        else
          "No image available"
        end
      end
    end
  end
end
