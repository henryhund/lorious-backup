class HomeController < ApplicationController
  def index
    @users = User.all
  end

  def landing_page
    if current_user
      redirect_to requests_path
    end
  end

  def thanks

  end

  def confirmed

  end
end
