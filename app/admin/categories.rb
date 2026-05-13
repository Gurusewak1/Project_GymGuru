ActiveAdmin.register Category do
  permit_params :name, :image_url

  form do |f|
    f.inputs do
      f.input :name
      f.input :image_url, label: "Category Image URL"
    end
    f.actions
  end

  index do
    selectable_column
    id_column

    column :image_url do |category|
      if category.image_url.present?
        image_tag(category.image_url, style: "width: 50px; height: 50px; object-fit: cover; border-radius: 8px;")
      else
        "No Image"
      end
    end

    column :name
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :image_url do |category|
        if category.image_url.present?
          image_tag(category.image_url, style: "width: 120px; height: 120px; object-fit: cover;")
        end
      end
      row :created_at
      row :updated_at
    end
  end
end