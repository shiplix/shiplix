Rails.configuration.x.stripe = {
  :publishable_key => ENV['SHIPLIX_STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['SHIPLIX_STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.x.stripe[:secret_key]
