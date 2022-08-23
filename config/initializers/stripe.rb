Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key: ENV['STRIPE_SECRET_KEY'],
  signing_secret: ENV['STRIPE_WEBHOOK_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

# 3 lines above used to change order status

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed' do |event|

  end
end

StripeEvent.configure do |events|
  events.subscribe 'invoice.paid' do |event|
    order = Order.find_by(checkout_session_id: event.data.object.id)
    order.update(paid: true)
  end
end
