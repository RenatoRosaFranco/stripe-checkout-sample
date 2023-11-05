# frozen_string_literal: true

Rails.configuration.stripe = {
  publisable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key:     ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
