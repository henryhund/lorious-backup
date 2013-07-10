class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:finish_registration, :edit_incomplete_registration]

  def finish_registration
    authorize! :finish_registration, :users
    @user_id = params[:user_id]
    @chat_key = params[:chat_key]

    @user = User.find_by_id(@user_id)

    @appointment = Appointment.find_by_chat_key(@chat_key)

    if @user != @appointment.try(:host) && @user != @appointment.try(:attendee)
      
      @destination = "/chat/go/" + @user_id.to_s + @chat_key + "/error"

      redirect_to @destination
    end
  end


  def edit_incomplete_registration
    authorize! :edit_incomplete_registration, :users
    @user_id = params[:user][:id]
    @chat_key = params[:user][:chat_key]
    @user = User.find_by_id(@user_id)
    
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.fully_registered = true
    @user.save

    @destination = "/chat/go/" + @user_id.to_s + "/" + @chat_key

    redirect_to @destination

  end

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def show
    authorize! :index, @user, :message => 'Not authorized as an administrator'
    @user = User.find(params[:id])
  end
  
  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  private

end