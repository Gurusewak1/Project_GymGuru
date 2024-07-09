class PagesController < ApplicationController
    before_action :authenticate_user!, only: [:home]
  
    def home
      # Your home action logic
    end
  
    def about
      # Your about action logic
    end
  
    def contact
      # Your contact action logic
    end
  end
  