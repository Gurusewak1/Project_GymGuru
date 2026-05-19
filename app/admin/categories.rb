ActiveAdmin.register Category do
  permit_params :name

  # Remove broken filters completely
  config.filters = false

  form do |f|
    f.inputs "Category Details" do
      f.input :name
    end
    f.actions
  end

  index do
    selectable_column
    id_column

    column :name

    column "Products Preview" do |category|
      category.products.limit(3).map do |product|
        if product.image_url.present?
          image_tag(
            product.image_url,
            style: "width: 40px; height: 40px; margin-right: 5px; border-radius: 6px;"
          )
        end
      end.join.html_safe
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :name

      row "Products" do |category|
        category.products.map do |product|
          if product.image_url.present?
            image_tag(
              product.image_url,
              style: "width: 60px; height: 60px; margin-right: 5px;"
            )
          end
        end.join.html_safe
      end

      row :created_at
      row :updated_at
    end
  end
end