class AppointmentsController < ApplicationController
  # GET /appointments
  # GET /appointments.json
  load_and_authorize_resource

  def confirm
    @appointment = Appointment.find(params[:id])
    @user = current_user

    if @user == @appointment.host
      @appointment.host_confirmed = true
    elsif @user == @appointment.attendee
      @appointment.attendee_confirmed = true
    else
      redirect_to user_dashboard_path, notice: "There was an error with your request."
      return
    end

    if @appointment.attendee_confirmed && @appointment.host_confirmed
    @subtotal = @appointment.fee * (@appointment.length.to_f/60)
    


    credit_transaction(@appointment.attendee, -1* @subtotal, nil, @appointment, "held")
  end

    @appointment.save
    redirect_to appointment_path(user_id:current_user.id, id:@appointment.id), notice: "You have confirmed! Please wait for your partner to confirm."
  end

  def index
    user = User.find(params[:user_id])
    @appointments_outstanding = user.hosted_appointments.where(completed: false)
    @appointments_completed = user.hosted_appointments.where(completed: true)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @appointments }
    end
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
    #@appointment = Appointment.find(params[:id])
    @conversation = Conversation.find(@appointment.conversation_id)
    @conversation.mark_as_read(current_user)
    @subtotal = @appointment.fee * (@appointment.length.to_f/60)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /appointments/new
  # GET /appointments/new.json
  def new
    #@appointment = Appointment.new
    @length_options = (30..360).step(30).map { |d| [ d < 60 ? "#{d.to_s} minutes" : "#{(d/60.round(1)).to_s} #{"hour".pluralize(d/60.round(1))}" , d.to_s ] }

    @host = User.find(params[:user_id])
    @attendee = current_user

    @fee = @host.profile.expertise_hourly
    @subtotal = @fee * 0.5
    @length = 30

    #generate random string to identify appointment
    o =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
    @hash  =  (0...10).map{ o[rand(o.length)] }.join

    #generate OpenTok Session ID
    # @opentok = OpenTok::OpenTokSDK.new ENV["OPENTOK_APIKEY"], ENV["OPENTOK_APISECRET"], :api_url => ENV["OPENTOK_URL"]
    # session_properties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"}    # or disabled
    # @location = "lorious.com"
    # @session_id = @opentok.create_session( @location, session_properties )

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /appointments/1/edit
  def edit
    #@appointment = Appointment.find(params[:id])
    @length_options = (30..360).step(30).map { |d| [ d < 60 ? "#{d.to_s} minutes" : "#{(d/60.round(1)).to_s} #{"hour".pluralize(d/60.round(1))}" , d.to_s ] }

    @host = @appointment.host
    @attendee = @appointment.attendee
    @fee = @appointment.fee
    @length = @appointment.length
    @time = @appointment.time.strftime("%B %d, %Y - %I:%M %p")
    @subtotal = @fee * (@length.to_f/60)

    @hash = @appointment.chat_key
    @session_id = @appointment.chat_session_id

    @conversation = Conversation.find(@appointment.conversation_id)
    @action = "edit"

  end

  # POST /appointments
  # POST /appointments.json
  def create
    #@appointment = Appointment.new(params[:appointment])
    
    #@appointment = Appointment.new
    @length_options = (30..360).step(30).map { |d| [ d < 60 ? "#{d.to_s} minutes" : "#{(d/60.round(1)).to_s} #{"hour".pluralize(d/60.round(1))}" , d.to_s ] }

    @host = User.find(params[:user_id])
    @attendee = current_user

    @fee = @host.profile.expertise_hourly

    #generate random string to identify appointment
    o =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
    @hash  =  (0...10).map{ o[rand(o.length)] }.join

    # put in appointment request attributes
    @appointment = Appointment.new
    @appointment_params = params[:appointment]
    @appointment.host = User.find(@appointment_params[:host_id])
    @appointment.attendee = User.find(@appointment_params[:attendee_id])
    @appointment.time = @appointment_params[:time]
    @appointment.fee = @appointment_params[:fee]
    @appointment.length = @appointment_params[:length]
    @appointment.attendee_confirmed = true
    @appointment.chat_key = @hash

    #send notice/message for appointment
    recipient_ids = params[:conversation][:recipients].split(',')
    recipients = User.where(slug: recipient_ids).all

    respond_to do |format|
      if @appointment.save
        conversation = current_user.
        send_message(recipients, params[:conversation][:body], "Appointment Request: #{@appointment.fee * (@appointment.length.to_f/60)} credits / #{@appointment.length} minutes").conversation

        @appointment.conversation_id = conversation.id
        @appointment.save

        format.html { redirect_to appointment_path(id: @appointment.id, user_id: current_user.slug), notice: 'Appointment was successfully created.' }
        format.json { render json: @appointment, status: :created, location: @appointment }
      else
        format.html { render action: "new" }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /appointments/1
  # PUT /appointments/1.json
  def update
    #@appointment = Appointment.find(params[:id])
    @conversation = Conversation.find(@appointment.conversation_id)
    @user = current_user
    if @user == @appointment.host
      @appointment.host_confirmed = true
      @appointment.attendee_confirmed = false
      free_credits(@appointment)
    elsif @user == @appointment.attendee
      @appointment.attendee_confirmed = true
      @appointment.host_confirmed = false
      free_credits(@appointment)
    else
      redirect_to current_user, notice: "There was an error with your request."
      return
    end

    respond_to do |format|
      if @appointment.update_attributes(params[:appointment])
        current_user.reply_to_conversation(@conversation, params[:message][:body], @conversation.subject)
        format.html { redirect_to @appointment, notice: 'Appointment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    #@appointment = Appointment.find(params[:id])
    free_credits(@appointment)
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: "Appointment canceled." }
      format.json { head :no_content }
    end
  end
end
