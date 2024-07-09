ActiveAdmin.register_page "About Page" do
  content do
    # Custom form to edit about page content
    render partial: 'admin/pages/about_form', locals: { page_content: @about_page.content }
  end

  controller do
    def edit
      @about_page = AboutPage.first_or_create # Adjust according to your model logic
    end

    def update
      @about_page = AboutPage.find(params[:id])
      if @about_page.update(page_params)
        redirect_to admin_dashboard_path, notice: 'About page content updated successfully.'
      else
        render :edit
      end
    end

    private

    def page_params
      params.require(:about_page).permit(:content)
    end
  end
end
