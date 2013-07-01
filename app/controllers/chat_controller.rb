class ChatController < ApplicationController
  def test
  end

  def index
  end

  def new
    @opentok = OpenTok::OpenTokSDK.new ENV["OPENTOK_APIKEY"], ENV["OPENTOK_APISECRET"], :api_url => ENV["OPENTOK_URL"]
    session_properties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"}    # or disabled

    @session_id = @opentok.create_session( @location, session_properties )
    redirect_to "/chat/#{@session_id}"
  end

  def chat
    @session_id = params[:session_id]

    @opentok = OpenTok::OpenTokSDK.new ENV["OPENTOK_APIKEY"], ENV["OPENTOK_APISECRET"], :api_url => ENV["OPENTOK_URL"]
    @location = "localhost"
    

    @token = @opentok.generate_token :session_id => @session_id, :role => OpenTok::RoleConstants::PUBLISHER
  end
end
