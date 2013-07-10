class ChatController < ApplicationController
  authorize_resource :class => false
  def test
    @opentok = OpenTok::OpenTokSDK.new ENV["OPENTOK_APIKEY"], ENV["OPENTOK_APISECRET"], :api_url => ENV["OPENTOK_URL"]
    session_properties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"}    # or disabled
    @location = ENV["LOCATION"]
    @session_id = @opentok.create_session( @location, session_properties )
    @token = @opentok.generate_token :session_id => @session_id, :role => OpenTok::RoleConstants::PUBLISHER
  end

  def index
  end

  def new
    @opentok = OpenTok::OpenTokSDK.new ENV["OPENTOK_APIKEY"], ENV["OPENTOK_APISECRET"], :api_url => ENV["OPENTOK_URL"]
    session_properties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"}    # or disabled
    @location = ENV["LOCATION"]
    @session_id = @opentok.create_session( @location, session_properties )
    redirect_to "/chat/#{@session_id}"
  end

  def chat
    @session_id = params[:session_id]

    @opentok = OpenTok::OpenTokSDK.new ENV["OPENTOK_APIKEY"], ENV["OPENTOK_APISECRET"], :api_url => ENV["OPENTOK_URL"]
    

    @token = @opentok.generate_token :session_id => @session_id, :role => OpenTok::RoleConstants::PUBLISHER
  end

  def chat_prep
    @user_id = params[:user_id]
    @chat_key = params[:chat_key]

    @user = User.find_by_id(@user_id)

    if @user.try(:fully_registered)
      @status = "start"
    elsif !@user.try(:fully_registered)
      @status = "register"
    else
      @status = "error"
    end

    @appointment = Appointment.find_by_chat_key(@chat_key)

    if @user != @appointment.try(:host) && @user != @appointment.try(:attendee)
      @status = "error"
    end

    @destination = "/chat/go/" + @user_id.to_s + "/" + @chat_key + "/" + @status

    redirect_to @destination
    

  end

  def scheduled_chat
    @user_id = params[:user_id]
    @chat_key = params[:chat_key]

    @user = User.find_by_id(@user_id)

    if @user.try(:fully_registered)

      @appointment = Appointment.find_by_chat_key(@chat_key)

      @session_id = @appointment.chat_session_id

      @opentok = OpenTok::OpenTokSDK.new ENV["OPENTOK_APIKEY"], ENV["OPENTOK_APISECRET"], :api_url => ENV["OPENTOK_URL"]
      
      @token = @opentok.generate_token :session_id => @session_id, :role => OpenTok::RoleConstants::PUBLISHER

      @after_route =  "/chat/go/" + @user_id.to_s + "/" + @chat_key + "/end"

      @user == @appointment.host ? @user_type = "host" : @user_type = "attendee"

    else
      @destination = "/chat/go/" + @user_id.to_s + "/" + @chat_key + "/register"
      redirect_to @destination
    end

  end

  def chat_end
    @user_id = params[:user_id]
    @chat_key = params[:chat_key]

    @user = User.find_by_id(@user_id)

    @appointment = Appointment.find_by_chat_key(@chat_key)

    if @user == @appointment.host
      @user_type = "host"
    elsif @user == @appointment.attendee
       @user_type = "attendee"
    else
      @destination = "/chat/go/" + @user_id.to_s + "/" + @chat_key + "/error"
      redirect_to @destination
    end

    send_mail("Appointments @ Lorious", "admin@lorious.com", "Team Lorious", "admin@lorious.com", "Lorious ADMIN | Appointment completed", "Appointment completed!\r\n\r\nHost: #{@appointment.host.profile.name}\r\n\r\n Attendee: #{@appointment.attendee.profile.name}\r\n\r\nLogin here: #{ENV["LOCATION"]}/login\r\nView requests here: #{ENV["LOCATION"]}/appointments")    

    @appointment.completed = true

    @appointment.save

    #@review = @appointment.review.new

  end
end
