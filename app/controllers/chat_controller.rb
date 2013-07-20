class ChatController < ApplicationController
  # before_filter :require_login, except: [:test]
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

  # def chat_prep
  #   authorize


  #   @user_id = params[:user_id]
  #   @chat_key = params[:chat_key]

  #   @user = User.find_by_id(@user_id)

  #   if @user.try(:fully_registered)
  #     @status = "start"
  #   elsif !@user.try(:fully_registered)
  #     @status = "register"
  #   else
  #     @status = "error"
  #   end

  #   @appointment = Appointment.find_by_chat_key(@chat_key)

  #   if @user != @appointment.try(:host) && @user != @appointment.try(:attendee)
  #     @status = "error"
  #   end

  #   @destination = "/chat/go/" + @user_id.to_s + "/" + @chat_key + "/" + @status

  #   redirect_to @destination
    

  # end

  def scheduled_chat
    if !anyone_signed_in?
      deny_access
    elsif user_signed_in?

      # @user_id = params[:user_id]
      @chat_key = params[:chat_key]

      # @user = User.find_by_id(@user_id)

      @appointment = Appointment.find_by_chat_key(@chat_key)

      if current_user == @appointment.host || current_user == @appointment.attendee

        @session_id = @appointment.chat_session_id

        @opentok = OpenTok::OpenTokSDK.new ENV["OPENTOK_APIKEY"], ENV["OPENTOK_APISECRET"], :api_url => ENV["OPENTOK_URL"]
        @token = @opentok.generate_token :session_id => @session_id, :role => OpenTok::RoleConstants::PUBLISHER

        @after_route =  "/chat/go/" + @chat_key + "/end"

        current_user == @appointment.host ? @user_type = "host" : @user_type = "attendee"
        
        @host_name = @appointment.host.profile.name
        @attendee_name = @appointment.attendee.profile.name
      else
        flash[:info] = 'You are not authorized to participate in this video chat'
        redirect_to root_path
      end

    else
    end


  end

  def chat_end
    if !anyone_signed_in?
      deny_access
    elsif user_signed_in?
      @user_id = params[:user_id]
      @chat_key = params[:chat_key]

      # @user = User.find_by_id(@user_id)

      @appointment = Appointment.find_by_chat_key(@chat_key)

      if current_user == @appointment.host || current_user == @appointment.attendee
        @host_name = @appointment.host.profile.name
        @attendee_name = @appointment.attendee.profile.name
        if current_user == @appointment.host
          @user_type = "host"
        elsif current_user == @appointment.attendee
          @user_type = "attendee"
          @review = @appointment.review
          if @review.nil?
            @review = Review.new
            @review.appointment_id = @appointment.id
            @review.reviewer_id = current_user.id
            @review.reviewee_id = @appointment.host.id
            @review.rating = 0
          end
        else
          @destination = "/chat/go/" + @chat_key + "/error"
          redirect_to @destination
        end

        # send_mail("Appointments @ Lorious", "admin@lorious.com", "Team Lorious", "admin@lorious.com", "Lorious ADMIN | Appointment completed", "Appointment completed!\r\n\r\nHost: #{@appointment.host.profile.name}\r\n\r\n Attendee: #{@appointment.attendee.profile.name}\r\n\r\nLogin here: #{ENV["LOCATION"]}/login\r\nView requests here: #{ENV["LOCATION"]}/appointments")    

        @appointment.completed = true

        @appointment.save


      else
        flash[:info] = 'You are not authorized to participate in this video chat'
        redirect_to root_path
      end

    else
    end
  end


  def report_listener

    # data = params[:data]
    chat_action = params[:chat_action]
    chat_user_id = params[:chat_user_id]
    session_id = params[:session_id]

    logger.info(chat_action+" "+chat_user_id +" " + session_id)

    if chat_action == "connect"
      record = SessionRecord.find_by_chat_session_id(session_id, order: "created_at DESC")
      
      if record == nil
        SessionRecord.create(user_id_1: chat_user_id, chat_session_id: session_id)

      elsif record.try(:disconnected_at) != nil
        SessionRecord.create(user_id_1: chat_user_id, chat_session_id: session_id)


      end


    elsif chat_action == "disconnect"
      record = SessionRecord.find_by_chat_session_id(session_id, order: "created_at DESC")

      if record.try(:disconnected_at) == nil
        record.user_id_2 = chat_user_id
        record.disconnected_at = Time.now
        record.save
      else
        # Error!
        send_mail("Errors @ Lorious", "admin@lorious.com", "Team", "admin@lorious.com", "Lorious ADMIN | Error In Recording Chat Length Reported!!!!", "Error reported\r\n\r\nPage: #{@uri}\r\n\r\nPage: #{@referer}")

        
      end


    end
    respond_to do |format| format.html { render :nothing => true } end
  end

  private

  def require_login
    unless current_user
      redirect_to login_url
    end
  end

end
