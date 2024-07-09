class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
def index
  @products = Product.all
end

# GET /admin/products/1
def show
  @product = Product.find(params[:id])  # Ensure this line fetches the correct product

end

# GET /admin/products/new
def new
  @product = Product.new
end

# GET /admin/products/1/edit
def edit
end

def home
  # Logic for home page related to products
end

def about
  # Logic for about page related to products
end

# POST /admin/products
def create
  @product = Product.new(product_params)

  if @product.save
    redirect_to admin_product_path(@product), notice: 'Product was successfully created.'
  else
    render :new
  end
end

# PATCH/PUT /admin/products/1
def update
  if @product.update(product_params)
    redirect_to admin_product_path(@product), notice: 'Product was successfully updated.'
  else
    render :edit
  end
end

# DELETE /admin/products/1
def destroy
  @product.destroy
  redirect_to admin_products_path, notice: 'Product was successfully deleted.'
end

private

# Use callbacks to share common setup or constraints between actions.
def set_product
  @product = Product.find(params[:id])
end

# Only allow a trusted parameter "white list" through.
def product_params
  params.require(:product).permit(:name, :description, :price, :category)
end
end