class ProfilesController < ApplicationController

  # before_filter :check_for_profile, only: [:create]

  load_and_authorize_resource
  # skip_authorize_resource only: [:create_before_signup, :update_before_signup]
  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
    @original_niche = get_subscriber_details(@profiles, "niche")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    # @profile = Profile.find(params[:id])
    redirect_to user_page_url(@profile.user)
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    # @profile = Profile.new


    

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @user = current_user
    @profile = @user.profile
  end

  # POST /profiles
  # POST /profiles.json
  def create
    # TO DO: make this for just generic creation.
    @profile = Profile.find_by_email(params[:profile][:email])
    @profile.user_id = current_user.id

    if @profile.nil?
      @profile = Profile.new(params[:profile])
      add_to_list_niche(params[:profile][:fname], params[:profile][:email], params[:profile][:niche], list_id=ENV["MAILCHIMP_LISTID"])
      @profile.save
    else
      @profile.update_attributes(params[:profile])
    end

    redirect_to profiles_path, notice: 'Profile was successfully created.' 
    # format.json { render json: @profile, status: :created, location: @profile }
  end

  # def create_before_signup
  #   # find_or_create
  #   @user = User.find_by_email(params[:profile][:email])
  #   if @user.blank?
  #     session[:new_profile] = true
  #     add_to_list_niche(params[:profile][:fname], params[:profile][:email], params[:profile][:niche], list_id=ENV["MAILCHIMP_LISTID"])
      

  #     # create a new user
  #     @user = User.new(email: params[:profile][:email], password: Devise.friendly_token[0,20], name: params[:profile][:fname])    
  #     @user.skip_confirmation!
  #     @user.save!

  #     #create a user profile
  #     @profile = Profile.new(user_id: @user.id, fname: params[:profile][:fname], email: params[:profile][:email], niche: params[:profile][:niche])
  #     @profile.save
  #   else
  #     #update if user already exists
  #     session[:new_profile] = false
  #     @user.name = params[:profile][:fname]
  #     @user.skip_confirmation!
  #     @user.save!
      
  #     @profile = Profile.find_by_user_id(@user.id)
      
  #     if @profile.blank?
  #       @profile = Profile.new(user_id: @user.id, fname: params[:profile][:fname], email: params[:profile][:email], niche: params[:profile][:niche])
  #       @profile.save
  #     else
  #     @user.profile.update_attributes(params[:profile])
  #     @profile = @user.profile
  #     end
  #   end


  #   session[:email] = @user.email
  #   redirect_to welcome_path, notice: 'Profile was successfully created.' 
  #       # format.json { render json: @profile, status: :created, location: @profile }
  # end

  # # def create_before_signup_BACKUP
  # #   @profile = Profile.find_by_email(params[:profile][:email])
  # #   if @profile.nil?
  # #     @profile = Profile.new(params[:profile])
  # #     session[:new_profile] = true
  # #     add_to_list_niche(params[:profile][:fname], params[:profile][:email], params[:profile][:niche], list_id=ENV["MAILCHIMP_LISTID"])
  # #   else
  # #     session[:new_profile] = false
  # #   end

  # #     if session[:new_profile] == true
  # #       @profile.save
  # #     else
  # #       @profile.update_attributes(params[:profile])
  # #     end

  # #       session[:email] = @profile.email
  # #       redirect_to welcome_path, notice: 'Profile was successfully created.' 
  # #       # format.json { render json: @profile, status: :created, location: @profile }
  # # end

  # # PUT /profiles/1
  # # PUT /profiles/1.json
  
  # def update_before_signup
  #   @profile = Profile.find_by_email(session[:email])
  #   # update_list_subscription(email, "USER_TYPE", "both")
  #   @profile.update_attributes(params[:profile])
  #   @count = 0
  #   @user_type = "none"

  #   @fname = params[:profile][:fname]
  #   @lname = params[:profile][:lname]

  #   @name = @fname + " " + @lname

  #   @user = User.find_by_email(session[:email])

  #   @user.name = @name
  #   @user.save

  #     unless params[:request_exp].try(:[],:expertise) == ""
  #       @request_exp = @profile.requests.new
  #       @request_exp.request_type = "expert"
  #       @request_exp.expertise = params[:request_exp][:expertise]
  #       @request_exp.max_rate = params[:request_exp][:max_rate].to_s.gsub(/[^\d\.]/, '').to_d
  #       @request_exp.save
  #       @count += 1

  #       @user_type = "expert"
  #     end

  #     unless params[:request_int].try(:[],:expertise) == ""
  #       @request_int = @profile.requests.new
  #       @request_int.request_type = "user"
  #       @request_int.expertise = params[:request_int][:expertise]
  #       @request_int.horizon = params[:request_int][:horizon]
  #       @request_int.time_needed = params[:request_int][:time_needed]
  #       @request_int.max_rate = params[:request_int][:max_rate].to_s.gsub(/[^\d\.]/, '').to_d
  #       @request_int.save
  #       @count += 1

  #       if @user_type == "expert"
  #         @user_type = "both"
  #       else
  #         @user_type = "user"
  #       end

  #       if @user_type.nil?
  #         #
  #       end

  #     end

  #     if @count > 0
  #       @count_pluralized = "request".pluralize(@count)
  #       send_mail("Admin @ Lorious", "notifications@lorious.com", "Admin Notifications", "henry@lorious.com", "Lorious ADMIN | #{@count} new #{@count_pluralized}!", "Login here: #{ENV["LOCATION"]}/login\r\nView requests here: #{ENV["LOCATION"]}/requests")
  #     end

  #       update_list_subscription(session[:email], "USER_TYPE", @user_type)

    

  #   redirect_to confirmed_path, notice: 'Profile was successfully updated.'

  # end


  def update
    # @profile = Profile.find(params[:id])
    # update_list_subscription("henryhund@gmail.com", "USER_TYPE", "both")
    current_user.profile.update_attributes(params[:profile])
    # @count = 0
    # if session[:email] == @profile.email
    #   unless params[:request_exp].try(:[],:expertise) == ""
    #     @request_exp = @profile.requests.new
    #     @request_exp.request_type = "expert"
    #     @request_exp.expertise = params[:request_exp][:expertise]
    #     @request_exp.max_rate = params[:request_exp][:max_rate].to_s.gsub(/[^\d\.]/, '').to_d
    #     @request_exp.save
    #     @count += 1
    #   end

    #   unless params[:request_int].try(:[],:expertise) == ""
    #     @request_int = @profile.requests.new
    #     @request_int.request_type = "user"
    #     @request_int.expertise = params[:request_int][:expertise]
    #     @request_int.horizon = params[:request_int][:horizon]
    #     @request_int.time_needed = params[:request_int][:time_needed]
    #     @request_int.max_rate = params[:request_int][:max_rate].to_s.gsub(/[^\d\.]/, '').to_d
    #     @request_int.save
    #     @count += 1
    #   end

    #   if @count > 0
    #     @count_pluralized = "request".pluralize(@count)
    #     send_mail("Admin @ Lorious", "notifications@lorious.com", "Admin Notifications", "henry@lorious.com", "Lorious ADMIN | #{@count} new #{@count_pluralized}!", "Login here: http://lorious-mvp.herokuapp.com/login\r\nView requests here: http://lorious-mvp.herokuapp.com/requests")
    #   end

    # end

    redirect_to user_dashboard_url(current_user.id), notice: 'Profile was successfully updated.'

  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    # @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :no_content }
    end
  end

  private

  def check_for_profile
    @existing_profile = Profile.find_by_email(@profile.try(:email))
    unless @existing_profile.nil?
      session[:email] = @existing_profile.try(:email)
      redirect_to welcome_path
    end
  end
end
