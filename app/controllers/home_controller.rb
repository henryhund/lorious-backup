class HomeController < ApplicationController
  def index
    @users = User.all
  end

  def landing_page
  end

  def thanks

  end

  def confirmed

  end
end
