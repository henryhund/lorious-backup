class HomeController < ApplicationController
  def index
    # @users = User.all
  end

  def audience_home
    @action = params[:action]
    @disable_header = true
    @profile = Profile.new
    @niche = params[:niche] || "crafting"


    case @niche
    when "crafting"
      @headline = "Your central place for crafting help"
    else
      @headline = "Welcome to Lorious!"
    end

  end

  def blog_home
    @action = params[:action]
    @disable_header = true
    @profile = Profile.new
    @niche = params[:niche] || "blogging"


    case @niche
    when "blogging"
      @headline = "Engage your audience through video."
    else
      @headline = "Welcome to Lorious!"
    end
  end

  def faq

  end

  def more
    @email = session[:email]
    @profile = Profile.find_by_email(@email)
    @request = Request.new

    case @profile.niche
    when "crafting"
      @sample_expertise = "knitting, decorating, terrariums"
      @sample_interest = "jewelry, painting, design"
    else
      @sample_expertise = "anything!"
      @sample_interest = "anything!"
    end
      
  end

  # def thanks

  # end

  def confirmed
    
    add_to_list_niche(params[:waiting_list_signup][:fname], params[:waiting_list_signup][:email], params[:waiting_list_signup][:niche], list_id=ENV["MAILCHIMP_LISTID"])
    
    if params[:waiting_list_signup][:user_type] == "expert"
      update_list_subscription(params[:waiting_list_signup][:email], "EXPERT", "true", list_id=ENV["MAILCHIMP_LISTID"])
    elsif params[:waiting_list_signup][:user_type] == "user"
      update_list_subscription(params[:waiting_list_signup][:email], "USER", "true", list_id=ENV["MAILCHIMP_LISTID"])
    end

    # if session[:new_profile] == true
    #   @profile = Profile.find_by_email(session[:email])
      # send_mail("Henry from Lorious", "henry@lorious.com", 
      #   @profile.name, 
      #   session[:email], 
      #   "Lorious | #{@profile.fname} - Welcome to Lorious!", 
      #   "Hi #{@profile.fname},
      #   \r\nThank you for signing up for Lorious! We can't wait to start connecting you to our community.
      #   \r\nLorious is an online marketplace for knowledge and expertise. People like you turn to Lorious in search of experts for advice, to solve a problem or to learn a new skill. We hope to help you and all of our users grow and succeed by giving you convenient access via to the experts you need.
      #   \r\nWe hope you will be one of the first members of our community, which will start as an exclusive group of people committed to learning and helping others to learn. Your feedback will be incredibly valuable in shaping our ability to help our community succeed.
      #   \r\nWe'll get back to you as soon as we possibly can so we can get started with helping you tackle your challenges.
      #   \r\nSincerely,
      #   \r\nHenry, co-founder, http://www.lorious.com")

  end

  def error
    @referer = request.env['HTTP_REFERER']
    @uri = request.env['REQUEST_URI']
    send_mail("Errors @ Lorious", "admin@lorious.com", "Team", "admin@lorious.com", "Lorious ADMIN | Error Reported", "Error reported\r\n\r\nPage: #{@uri}\r\n\r\nPage: #{@referer}")
    redirect_to "/"
  end

  def message
    # send_mail(from_name, from_email, to_name, to_email, subject, *content)
    # content[0]=text, content[1]=html (optional)
    # send_mail("Henry", 
    #           "henry@xxx", 
    #           "Hank", 
    #           "hhund@xxx", 
    #           "Test message", 
    #           "text", 
    #           "<h3>but I prefer HTML</h3>")

    # add_to_list("Hank","henry@lorious.com")
  end

  def legal

  end

end
