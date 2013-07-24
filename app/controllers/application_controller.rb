class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

    # Customize the Devise after_sign_in_path_for() for redirecct to previous page after login
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :user, User
      store_location = session[:return_to]
      clear_stored_location
      (store_location.nil?) ? "/" : store_location.to_s
    else
      super
    end
  end

  

  def add_to_list(fname, email, list_id=ENV["MAILCHIMP_LISTID"])
    #set up Mailchimp API
    gb = Gibbon.new(ENV["MAILCHIMP_APIKEY"])
    gb.throws_exceptions  = false

    #Add subscriber, do not send double opt-in message (already sending a message from Mandrill)
    gb.list_subscribe(
                      {
                        id: list_id,
                        email_address: email,
                        double_optin: false,
                        merge_vars: {
                          FNAME: fname
                        }
                      }
                      )
  end

  def add_to_list_niche(fname, email, niche, list_id=ENV["MAILCHIMP_LISTID"])
    #set up Mailchimp API
    gb = Gibbon.new(ENV["MAILCHIMP_APIKEY"])
    gb.throws_exceptions  = false

    #Add subscriber, do not send double opt-in message (already sending a message from Mandrill)
    gb.list_subscribe(
                      {
                        id: list_id,
                        email_address: email,
                        double_optin: false,
                        merge_vars: {
                          FNAME: fname,
                          NICHE: niche
                        }
                      }
                      )


  end

 def update_list_subscription(email, field, data, list_id=ENV["MAILCHIMP_LISTID"])
    #set up Mailchimp API
    gb = Gibbon.new(ENV["MAILCHIMP_APIKEY"])
    gb.throws_exceptions  = false

    #Add subscriber, do not send double opt-in message (already sending a message from Mandrill)
    gb.listUpdateMember(
                      {
                        id: list_id,
                        email_address: email,
                        merge_vars: {
                          field.to_sym => data,

                        }
                      }
                      )


  end

  # def update_list_subscription(email, lname, niche, list_id=ENV["MAILCHIMP_LISTID"])
  #   #set up Mailchimp API
  #   gb = Gibbon.new(ENV["MAILCHIMP_APIKEY"])
  #   #gb.throws_exceptions  = false

  #   #Add subscriber, do not send double opt-in message (already sending a message from Mandrill)
  #   gb.listUpdateMember(
  #                     {
  #                       id: list_id,
  #                       email_address: email,
  #                       merge_vars: {
  #                         LNAME: lname,
  #                         NICHE: niche

  #                       }
  #                     }
  #                     )


  # end

  def get_subscriber_details(profiles, field, list_id=ENV["MAILCHIMP_LISTID"])
    gb = Gibbon.new(ENV["MAILCHIMP_APIKEY"])
    gb.throws_exceptions  = false
    result = {}
    profiles.each do |profile|
      email = profile.email
      info = gb.listMemberInfo({:id => list_id, :email_address => profile.email})
      result[email] = info[field]
    end
    result
  end

  def send_mail(from_name, from_email, to_name, to_email, subject, *content)
    # The gem assumes your API key is stored as an environment variable called MANDRILL_APIKEY
    require 'mandrill'
    m = Mandrill::API.new
    message = {
      from_name: from_name,
      from_email: from_email,
      to: [
        {
          email: to_email,
          name: to_name
        }
      ],
      subject: subject,
      text: content[0],
      html: content[1]
      }
      sending = m.messages.send message
      # puts sending
  end

  
  # Stripe customer check
  def stripe_customer?(user, redirect="new_customer_path")
    if user.stripe_customer_id && Stripe::Customer.retrieve(user.stripe_customer_id) && Stripe::Customer.retrieve(user.stripe_customer_id)["deleted"] != true
      return true
    elsif redirect
      redirect_to new_customer_path
    else
      return false
    end
  end

end
