class RecipientsController < ApplicationController

  #authorize_resource

  def index
    # user = current_user
    # if  !user.stripe_recipient_id.nil?
      redirect_to recipient_path(current_user)
    # end
  end

  def show
    user = current_user
    if user.stripe_recipient_id.nil?
      @display = "none"
    else

      recipient = Stripe::Recipient.retrieve(user.stripe_recipient_id)

      bank_account = recipient.active_account

      @bank_account_type = bank_account.bank_name
      
      @bank_account_name = recipient.name

      last4 = recipient.active_account.last4
      @bank_account_number = "****"+last4
    end
  end

  def new
    # @action = "new"
    if !current_user.stripe_recipient_id.nil?
      redirect_to recipients_path, notice: "We already have your bank_account on file. Thank you."
    end
  end

  def edit
    # @action = "edit"
    user = current_user


    recipient = Stripe::Recipient.retrieve(user.stripe_recipient_id)

    bank_account = recipient.active_account

    @bank_account_type = bank_account.bank_name
    
    @bank_account_name = recipient.name

    last4 = recipient.active_account.last4
    @bank_account_number = "****"+last4
    @bank_routing_number = "****"
  end

  def create
    user = current_user
    if !user.stripe_recipient_id.nil?
      old_recipient = Stripe::Recipient.retrieve(user.stripe_recipient_id)
      old_recipient.delete
    end

    token = params[:stripeToken]
    name = params["recipient"]["name"]
    recipient = Stripe::Recipient.create(
     :name => name,
     :email => current_user.email,
     :type => "individual",
     :bank_account => token
    )

     user.stripe_recipient_id = recipient.id

     if user.save
        redirect_to recipient_path(current_user)
      else
        redirect_to new_recipient_path, notice: 'Stripe error, please contact customer support.' 
      end

  end

  # note: will only use create action due to custom url on simple form
  # def update
  #   user = current_user

  #   old_recipient = Stripe::Recipient.retrieve(user.stripe_recipient_id)
  #   old_recipient.delete
  #   @old_bank_account = user.bank_account.delete

  #   token = params[:stripeToken]
  #   name = params["recipient"]["name"]
  #   recipient = Stripe::Recipient.create(
  #    :name => name,
  #    :email => current_user.email,
  #    :type => "individual",
  #    :bank_account => token
  #   )
  #   current_user.stripe_recipient_id = recipient.id


  #   respond_to do |format|
  #     if current_user.save
  #       format.html { redirect_to @recipien, notice: 'Bank Account was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @bank_account.errors, status: :unprocessable_entity }
  #     end
  #   end

  # end

  def destroy
    user = current_user
    recipient = Stripe::Recipient.retrieve(user.stripe_recipient_id)
    recipient.delete

    user.stripe_recipient_id = nil
    user.save

    respond_to do |format|
      format.html { redirect_to recipients_url, notice: "Bank Account deleted. You should add another before your next paid chat." }
      format.json { head :no_content }
    end
  end

  # def edit
  #   user = current_user
  #   stripe_customer?(user)

  # end

  # def create

  # end

  # def update

  # end

  # def show

  # end

end


#   def new
#     unless current_user.stripe_customer_id.nil?
#       @customer = Stripe::Customer.retrieve(current_user.stripe_customer_id) # get stripe customer info
#       # @view_customer = JSON.parse(@customer)
#     end
#   end

#   def create
#     customer = Stripe::Customer.create(
#       :email => 'example@stripe.com',
#       :card  => params[:stripeToken]
#     )

#     user = current_user
#     user.stripe_customer_id = customer.id
#     if user.save
#       redirect_to customers_path, notice: 'Card info was successfully saved.' 
#     else
#       redirect_to customers_path, notice: 'Card could not be saved.' 
#     end


#     # charge = Stripe::Charge.create(
#     #   :customer    => customer.id,
#     #   :amount      => @amount,
#     #   :description => 'Rails Stripe customer',
#     #   :currency    => 'usd'
#     # )

#     rescue Stripe::CardError => e
#       flash[:error] = e.message
#       redirect_to customers_path
#   end

#   def edit
#       @customer = Stripe::Customer.retrieve(current_user.stripe_customer_id) # get stripe customer info
#   end

#   def update
#     cu = Stripe::Customer.retrieve(current_user.stripe_customer_id)
#     card = customer.cards.retrieve
#     cu.cards.create(number: params[:number], exp_month: params[:exp_month], exp_year: params[:exp_year], cvc: params[:cvc], name: params[:name])
#   end

# end
