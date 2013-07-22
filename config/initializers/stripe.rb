Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLEKEY'],
  :secret_key      => ENV['STRIPE_SECRETKEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]