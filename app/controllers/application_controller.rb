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


  # Stripe check if card on file
  def stripe_card_on_file?(user)
    stripe_customer?(user)
    
    customer = Stripe::Customer.retrieve(user.stripe_customer_id)

    begin
    card = customer.cards.retrieve(user.card.stripe_card_id)

    rescue => e
      unless user.card.nil?
        user.card.delete
      end
      return false
    end
    return card
  end


  # Stripe customer check
  def stripe_recipient?(user)
    if user.stripe_recipient_id && Stripe::Recipient.retrieve(user.stripe_recipient_id) && Stripe::Recipient.retrieve(user.stripe_recipient_id)["deleted"] != true
      return true
    else
      redirect_to new_recipient_path
    end
  end

  # Transactions
  def payment(user, amount_in_usd)
  begin
    if amount_in_usd < 20
      redirect_to credit_packages_path, notice: "Minimum order is $20"
    end
    amount = amount_in_usd * 100 # amount in cents as reqd by stripe
    customer = Stripe::Customer.retrieve(user.stripe_customer_id)

    card = customer.cards.retrieve(user.card.stripe_card_id)

    charge = Stripe::Charge.create(
      amount: amount,
      currency: "usd",
      customer: customer.id,
      card: card.id,
      description: "Buying $#{amount_in_usd} for #{user.email} / #{user.username} / #{user.id}"
      )

  rescue
    send_mail("Errors @ Lorious", "admin@lorious.com", "Team", "admin@lorious.com", "Lorious ADMIN | Error In Buying Something Reported!", "Error reported\r\n\r\nIt appears that #{user.email} / #{user.username} / #{user.id} was attempting to pay $#{amount} and an error was reported. The Stripe Charge ID was reported as #{charge.try(:id)}. Please verify this transaction and mark it in the database appropriately.")
    redirect_to new_card_path(id: user.id), notice: "There is a problem with your card on file. Please update your information before you proceed."
  end

  if charge.id.nil?
    redirect_to new_card_path(id: user.id), notice: "There is a problem with your card on file. Please update your information before you proceed."
  else

    transaction = Transaction.new
    transaction.user_id = user.id
    # transaction.credit_id = credit.id
    transaction.stripe_charge_id = charge.id
    transaction.transaction_type = "buy credits"
    transaction.status = "paid"
    transaction.amount = amount_in_usd
    transaction.save
  end
  
  return transaction
  end

  def withdrawal()
    #check if withdrawal meets min balance
    #if so, make withdrawal to user's stripe bank account
  end


  def credit_transaction(user, number, transaction)
    credit = Credit.new
    credit.number = number
    credit.transaction_id = transaction.id

    credit.user_id = user.id

    o =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
    credit.hash_id =  (0...15).map{ o[rand(o.length)] }.join

    credit.save
  end

end
