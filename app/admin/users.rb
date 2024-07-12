ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :admin, :address, :province

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :address
      f.input :province
     
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :address
    column :province
    column :password
    actions
  end

  filter :email
  
end
