class CustomersController < ApplicationController

  def new
    unless current_user.stripe_customer_id.nil?
      @customer = Stripe::Customer.retrieve(current_user.stripe_customer_id) # get stripe customer info
      # @view_customer = JSON.parse(@customer)
    end
  end

  def create
    @amount = 1000
    customer = Stripe::Customer.create(
      :email => 'example@stripe.com',
      :card  => params[:stripeToken]
    )

    user = current_user
    user.stripe_customer_id = customer.id
    if user.save
      redirect_to customers_path, notice: 'Card info was successfully saved.' 
    else
      redirect_to customers_path, notice: 'Card could not be saved.' 
    end


    # charge = Stripe::Charge.create(
    #   :customer    => customer.id,
    #   :amount      => @amount,
    #   :description => 'Rails Stripe customer',
    #   :currency    => 'usd'
    # )

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to customers_path
  end

  def edit
      @customer = Stripe::Customer.retrieve(current_user.stripe_customer_id) # get stripe customer info
  end

  def update
    cu = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    cu.cards.create(number: params[:number], exp_month: params[:exp_month], exp_year: params[:exp_year], cvc: params[:cvc], name: params[:name])
  end

end
