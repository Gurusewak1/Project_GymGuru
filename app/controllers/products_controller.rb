class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all

    # Filter products based on the query parameters
    if params[:filter] == 'new'
      @products = @products.where("created_at >= ?", 1.hour.ago)
    elsif params[:filter] == 'recently_updated'
      @products = @products.where("updated_at >= ?", 1.hour.ago)
    elsif params[:filter] == 'on_sale'
      @products = @products.where("on_sale > ?", 0)
    end

    if params[:category].present?
      @products = @products.where(category_id: params[:category])
    end

    if params[:search].present?
      @products = @products.where("name LIKE ?", "%#{params[:search]}%")
    end

    @products = @products.page(params[:page]).per(5) # Paginate with 5 products per page
  end

  # GET /products/1
  def show
    # @product is already set by the before_action :set_product
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    # @product is already set by the before_action :set_product
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to product_path(@product), notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to product_path(@product), notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_path, notice: 'Product was successfully deleted.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name, :description, :price, :category_id, :on_sale)
  end
end
