class UsersController < ApplicationController
  # before_filter :authenticate_user!, except: [:update, :show, :finish_registration, :edit_incomplete_registration]
  load_and_authorize_resource

  def dashboard
    @user = current_user

    @appointments = Appointment.find(:all, conditions: ['host_id = ? OR attendee_id = ?', @user.id, @user.id])

  end

  # def finish_registration
  #   #authorize! :finish_registration, :users
  #   @user_id = params[:user_id]
  #   @chat_key = params[:chat_key]

  #   @user = User.find_by_id(@user_id)

  #   @appointment = Appointment.find_by_chat_key(@chat_key)

  #   if @user != @appointment.try(:host) && @user != @appointment.try(:attendee)
      
  #     @destination = "/chat/go/" + @user_id.to_s + @chat_key + "/error"

  #     redirect_to @destination
  #   end
  # end


  # def edit_incomplete_registration
  #   authorize! :edit_incomplete_registration, :users
  #   @user_id = current_user.id
  #   @user_id ||= params[:user][:id]
    
  #   @chat_key = params[:user][:chat_key]
  #   @user = User.find_by_id(@user_id)
    
  #   @user.password = params[:user][:password]
  #   @user.password_confirmation = params[:user][:password_confirmation]
  #   @user.fully_registered = true
  #   @user.save

  #   @destination = "/chat/go/" + @user_id.to_s + "/" + @chat_key

  #   redirect_to @destination

  # end

  def index
    # authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def show
    # authorize! :show, @user, :message => 'Not authorized as an administrator'
    @user_id = params[:id]
    @user_id ||= current_user.id

    @user = User.find(@user_id)
    @profile = @user.profile


    if @user.profile == nil
      @display = "none"
    else
    # for now, make @display always = all for dev; later, will allow user to set privacy

    @display = "all"
    end

    # if @user.profile.privacy == "private" && current_user != @user.id
    #   @display = "none"
    # else
    #   @display = "all"
    # end
  end
  
  def update
    #authorize! :update, @user, :message => 'Not authorized as an administrator.'
    
    @user = User.find(params[:id]) || current_user
    @profile = @user.profile
    if current_user.has_role? :admin
      if @user.update_attributes(params[:user], as: :admin)
        redirect_to users_path, :notice => "User updated."
      else
        redirect_to users_path, :alert => "Unable to update user."
      end
    else
      if @user.update_attributes(params[:user])
        redirect_to @user, :notice => "User updated."
      else
        # flash[:error] = @user.errors.to_a
        redirect_to @user, :alert => "Unable to update user."
      end
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

  # def update_avatar
  #   #authorize! :update, @user, :message => 'Not authorized as an administrator.'
    
  #   @user = User.find(params[:id]) unless params[:id].blank?
  #   @user ||= current_user
  #   @profile = @user.profile
  #   if current_user.has_role? :admin
  #     if @user.update_attributes(params[:user], as: :admin)
  #       redirect_to users_path, :notice => "User updated."
  #     else
  #       redirect_to users_path, :alert => "Unable to update user."
  #     end
  #   else
  #     if @user.update_attributes(params[:user])
  #       redirect_to @user, :notice => "User updated."
  #     else
  #       render action: upload_avatar, :messages => @user.errors.to_a || "Unable to update user."
  #     end
  #   end
  # end


  def upload_avatar
    @action = params[:action]
    render "edit"
  end
  def make_expert
    authorize! :expert, @user, :message => 'Not authorized as an administrator.'
    @action = params[:action]
    render "edit"
  end

  private

end