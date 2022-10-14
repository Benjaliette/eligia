Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key: ENV['STRIPE_SECRET_KEY'],
  signing_secret: ENV['STRIPE_WEBHOOK_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed' do |event|
    user = User.find_by(email: event.data.object.customer_details.email)
    order = user.orders.last
    order.update(paid: true)
    Notification.create(
      content: "La demande de résiliation des contrats de #{order.deceased_first_name} #{order.deceased_last_name}
                a bien été prise en compte",
      order: order
    )

    doc_missing_count = order.order_documents.reject { |order_document| (order_document.document_file.attached? || order_document.document_input.present?) }.count

    if doc_missing_count >= 1
      Notification.create(
        content: "Il vous reste des documents à fournir pour démarrer certaines résiliations (il vous manque
        #{doc_missing_count} documents).",
        order: order
      )
    end
  end
end
