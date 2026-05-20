class ProductsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.includes(:category).all

    # FILTERS
    if params[:filter] == "new"
      @products = @products.where("created_at >= ?", 5.minutes.ago)

    elsif params[:filter] == "recently_updated"
      @products = @products.where("updated_at >= ?", 1.week.ago)

    elsif params[:filter] == "on_sale"
      @products = @products.where("on_sale > ?", 0)
    end

    # CATEGORY FILTER (dropdown by id)
    if params[:category].present?
      @products = @products.where(category_id: params[:category])
    end

    # SEARCH (name + description + category name)
    if params[:search].present?
      query = "%#{params[:search]}%"

      @products = @products.joins(:category).where(
        "products.name ILIKE :q
         OR products.description ILIKE :q
         OR categories.name ILIKE :q",
        q: query
      )
    end

    # ORDER + PAGINATION
    @products = @products.order(created_at: :desc)
    @products = @products.page(params[:page]).per(5)
  end

  # SHOW
  def show
  end

  # NEW
  def new
    @product = Product.new
  end

  # EDIT
  def edit
  end

  # CREATE
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to product_path(@product), notice: "Product was successfully created."
    else
      render :new
    end
  end

  # UPDATE
  def update
    if @product.update(product_params)
      redirect_to product_path(@product), notice: "Product was successfully updated."
    else
      render :edit
    end
  end

  # DELETE
  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product was successfully deleted."
  end

  # ADD TO CART
  def add_to_cart
    product_id = params[:id]

    session[:cart] ||= {}

    session[:cart][product_id] ||= 0
    session[:cart][product_id] += 1

    redirect_to cart_path, notice: "Product added to cart."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :category_id, :on_sale, :image)
  end
end