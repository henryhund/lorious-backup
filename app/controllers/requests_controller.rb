class RequestsController < ApplicationController
  # GET /requests
  # GET /requests.json

  load_and_authorize_resource

  def index
    @requests_user = Request.where(request_type:"user", finished: false).order("created_at ASC")
    @requests_expert = Request.where(request_type:"expert", finished: false).order("created_at ASC")

    @requests_history = Request.where(finished: true).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @requests }
    end
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
    # @request = Request.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @request }
    end
  end

  # GET /requests/new
  # GET /requests/new.json
  def new
    # @request = Request.new
    @name = params[:name]
    @email = params[:email]
    @expertise = params[:custom_Expertise]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @request }
    end
  end

  # GET /requests/1/edit
  def edit
    # @request = Request.find(params[:id])
  end

  # POST /requests
  # POST /requests.json
  def create
    # @request = Request.new(params[:request])

    respond_to do |format|
      if @request.save
        format.html { redirect_to confirmed_path, notice: 'Request was successfully created.' }
        format.json { render json: @request, status: :created, location: @request }
      else
        format.html { render action: "new" }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /requests/1
  # PUT /requests/1.json
  def update
    # @request = Request.find(params[:id])

    respond_to do |format|
      if @request.update_attributes(params[:request])
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    # @request = Request.find(params[:id])
    @request.destroy

    respond_to do |format|
      format.html { redirect_to requests_url }
      format.json { head :no_content }
    end
  end
end
