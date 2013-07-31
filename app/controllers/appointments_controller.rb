class AppointmentsController < ApplicationController
  # GET /appointments
  # GET /appointments.json
  load_and_authorize_resource

  def index
    @appointments_outstanding = Appointment.where(completed: false)
    @appointments_completed = Appointment.where(completed: true)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @appointments }
    end
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
    #@appointment = Appointment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /appointments/new
  # GET /appointments/new.json
  def new
    #@appointment = Appointment.new
    
    @host = User.find(params[:id])
    @attendee = current_user
    
    @fee = @appointment.fee
    @fee ||= @host.profile.expertise_hourly

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
    @hash = @appointment.chat_key
    @session_id = @appointment.chat_session_id
  end

  # POST /appointments
  # POST /appointments.json
  def create
    #@appointment = Appointment.new(params[:appointment])
    @host = User.find(params[:id])
    @attendee = current_user


    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: 'Appointment was successfully created.' }
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

    respond_to do |format|
      if @appointment.update_attributes(params[:appointment])
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
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to appointments_url }
      format.json { head :no_content }
    end
  end
end
