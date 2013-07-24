class CardsController < ApplicationController
  # GET /cards
  # GET /cards.json

  load_and_authorize_resource

  def index
    user = current_user
    if user.has_role? :admin 
      @cards = Card.all

    elsif  !user.card.nil?
      redirect_to card_path(user.card)
    end

  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    # @card = Card.find(params[:id])

    user = current_user
    if user.card.stripe_card_id.nil?
      @display = "none"
    else

      customer = Stripe::Customer.retrieve(user.stripe_customer_id)

      card = customer.cards.retrieve(user.card.stripe_card_id)

      @card_type = card["type"]
      
      @card_name = card["name"]

      last4 = card["last4"]
      @card_number = "****"+last4
      
      @card_exp = card["exp_month"].to_s + " / "+ card["exp_year"].to_s[2,3]
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @card }
    end
  end

  # GET /cards/new
  # GET /cards/new.json
  def new
    # @card = Card.new

    stripe_customer?(current_user)

    if !current_user.card.nil?
      redirect_to cards_path, notice: "We already have your card on file. Thank you."
    end

  end

  # GET /cards/1/edit
  def edit
    # @card = Card.find(params[:id])
    user = current_user

    customer = Stripe::Customer.retrieve(user.stripe_customer_id)

    card = customer.cards.retrieve(user.card.stripe_card_id)

    @card_name = card["name"]

    last4 = card["last4"]
    @card_number = "****************"+last4
    
    @card_exp = card["exp_month"].to_s + " / "+ card["exp_year"].to_s[2,3]

  end

  # POST /cards
  # POST /cards.json
  def create
    # @card = Card.new(params[:card])
    user = current_user
    token = params[:stripeToken]

    customer = Stripe::Customer.retrieve(user.stripe_customer_id)
    card = customer.cards.create({card: token})
    @card = Card.new
    @card.user_id = params["card"]["user_id"]
    @card.stripe_card_id = card["id"]


    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Card was successfully created.' }
        format.json { render json: @card, status: :created, location: @card }
      else
        format.html { render action: "new" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cards/1
  # PUT /cards/1.json
  def update
    # @card = Card.find(params[:id])
    user = current_user
    token = params[:stripeToken]

    customer = Stripe::Customer.retrieve(user.stripe_customer_id)
    old_card = customer.cards.retrieve(user.card.stripe_card_id)
    old_card.delete
    current_user.card.delete

    card = customer.cards.create({card: token})
    @card = Card.new
    @card.user_id = params["card"]["user_id"]
    @card.stripe_card_id = card["id"]

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    # @card = Card.find(params[:id])    
    user = current_user
    customer = Stripe::Customer.retrieve(user.stripe_customer_id)
    old_card = customer.cards.retrieve(current_user.card.stripe_card_id)
    old_card.delete

    @card.destroy

    respond_to do |format|
      format.html { redirect_to cards_url, notice: "Card deleted. You must add another before your next paid video chat." }
      format.json { head :no_content }
    end
  end
end
