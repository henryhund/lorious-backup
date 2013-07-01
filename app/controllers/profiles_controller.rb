class ProfilesController < ApplicationController

  # before_filter :check_for_profile, only: [:create]

  load_and_authorize_resource
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
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
    # @profile = Profile.find(params[:id])
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.find_by_email(params[:profile][:email])
    if @profile.nil?
      @profile = Profile.new(params[:profile])
      session[:new_profile] = true
      add_to_list_niche(params[:profile][:fname], params[:profile][:email], params[:profile][:niche], list_id=ENV["MAILCHIMP_LISTID"])
    else
      session[:new_profile] = false
    end

      if session[:new_profile] == true
        @profile.save
      else
        @profile.update_attributes(params[:profile])
      end

        session[:email] = @profile.email
        redirect_to welcome_path, notice: 'Profile was successfully created.' 
        # format.json { render json: @profile, status: :created, location: @profile }
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    # @profile = Profile.find(params[:id])
    @profile.update_attributes(params[:profile])
    if session[:email] == @profile.email
      unless params[:request_exp].try(:[],:expertise) == ""
        @request_exp = @profile.requests.new
        @request_exp.request_type = "expert"
        @request_exp.expertise = params[:request_exp][:expertise]
        @request_exp.max_rate = params[:request_exp][:max_rate].to_s.gsub(/[^\d\.]/, '').to_d
        @request_exp.save
      end

      unless params[:request_int].try(:[],:expertise) == ""
        @request_int = @profile.requests.new
        @request_int.request_type = "user"
        @request_int.expertise = params[:request_int][:expertise]
        @request_int.horizon = params[:request_int][:horizon]
        @request_int.time_needed = params[:request_int][:time_needed]
        @request_int.max_rate = params[:request_int][:max_rate].to_s.gsub(/[^\d\.]/, '').to_d
        @request_int.save
      end
    end

    redirect_to confirmed_path, notice: 'Profile was successfully updated.'

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
