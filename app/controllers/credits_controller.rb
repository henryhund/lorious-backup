class CreditsController < ApplicationController
  # GET /credits
  # GET /credits.json
  def index
    @credits = current_user.credits.page(params[:page]).per(15)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @credits }
    end
  end

  # GET /credits/1
  # GET /credits/1.json
  def show
    @credit = Credit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @credit }
    end
  end


  def credits_cart
    unless stripe_card_on_file?(current_user)
      redirect_to new_card_path(id: current_user.id), notice: "There is a problem with your card on file. Please update your information before you proceed."
      return
    end

    @credit = Credit.new
    @credit.attributes = params[:credit]

    @number = @credit.number
    @amount = @number

    if @credit.number.nil?
      redirect_to credit_packages_path
      return
    end

    customer = @customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)

    if current_user.card.nil? || current_user.card.stripe_card_id.nil?
      send_mail("Errors @ Lorious", "admin@lorious.com", "Team", "admin@lorious.com", "Lorious ADMIN | Removed Card Error Reported!", "Error reported\r\n\r\nIt appears that #{current_user.email} / #{current_user.username} / #{current_user.id} was buying #{@credit.number} for $#{@amount * 100} and an error was reported. Please verify this transaction and mark it in the database appropriately.")
      redirect_to new_card_path(id: current_user.id), notice: "There is a problem with your card on file. Please update your information before you proceed."
      return
    end

    card = customer.cards.retrieve(current_user.card.stripe_card_id)


    @card_type = card["type"]
    
    @card_name = card["name"]

    @last4 = card["last4"]
    @card_number = "****"+@last4
    
    @card_exp = card["exp_month"].to_s + " / "+ card["exp_year"].to_s[2,3]

  end

  def buy_credits
    @credit = Credit.new(params[:credit])
    @number = @credit.number
    amount = @number
    user = current_user
    
    transaction = payment(current_user, amount)
    credits = credit_transaction(current_user, @number, transaction, nil)

    respond_to do |format|
      if !transaction.nil? && !credits.nil?
      # receipt
      send_mail("Receipts from Lorious", "admin@lorious.com", user.name, user.email, "Lorious Receipts | Thank you for your purchase", "Thank you for your purchase. Now go start solving your challenges by booking an appointment today!\r\n\r\n#{ENV["location"]}\r\n\r\n-The Lorious Team")

        format.html { redirect_to root_path, notice: 'Credits were successfully purchased.' }
        format.json { render json: @credit, status: :created, location: @credit }
      else
        send_mail("Errors @ Lorious", "admin@lorious.com", "Team", "admin@lorious.com", "Lorious ADMIN | Error In Buying Credits Reported!", "Error reported\r\n\r\nIt appears that #{current_user.email} / #{current_user.username} / #{current_user.id} was buying #{@credit.number} for $#{amount} and an error was reported. Please verify this transaction and mark it in the database appropriately.")
        format.html { redirect_to root_path, notice: 'There was an error in processing your transaction. Please check your credit balance and contact customer support if you have any issues.' }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  def spend_credits
    # check to ensure credit balance > upcoming credit trans
    # # create negative credit trans and credit line item
    # # 
  end

  # GET /credits/new
  # GET /credits/new.json
  # def new
  #   @number = params[:number]
  #   @credit = Credit.new(number: @number)

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @credit }
  #   end
  # end

  # # GET /credits/1/edit
  # def edit
  #   @credit = Credit.find(params[:id])
  # end

  # # POST /credits
  # # POST /credits.json
  # def create
  #   @credit = Credit.new(params[:credit])

  #   respond_to do |format|
  #     if @credit.save
  #       format.html { redirect_to @credit, notice: 'Credit was successfully created.' }
  #       format.json { render json: @credit, status: :created, location: @credit }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @credit.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PUT /credits/1
  # # PUT /credits/1.json
  # def update
  #   @credit = Credit.find(params[:id])

  #   respond_to do |format|
  #     if @credit.update_attributes(params[:credit])
  #       format.html { redirect_to @credit, notice: 'Credit was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @credit.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /credits/1
  # # DELETE /credits/1.json
  # def destroy
  #   @credit = Credit.find(params[:id])
  #   @credit.destroy

  #   respond_to do |format|
  #     format.html { redirect_to credits_url }
  #     format.json { head :no_content }
  #   end
  # end
end
