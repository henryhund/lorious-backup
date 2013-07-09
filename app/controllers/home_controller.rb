class HomeController < ApplicationController
  def index
    # @users = User.all
  end

  def landing_page
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
    if session[:new_profile] == true
      @profile = Profile.find_by_email(session[:email])
      send_mail("Henry @ Lorious", "henry@lorious.com", @profile.name, session[:email], "Lorious | Welcome to Lorious!", "Hi #{@profile.fname},\r\n\r\nThanks for signing up to learn more about Lorious! We can't wait to begin helping to connect you with interesting people. We will get back to you as soon as possible.\r\n\r\nIn the meantime, we will keep you up to date with what is going on at Lorious form time to time.\r\n\r\n-Henry")
    end

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
end
