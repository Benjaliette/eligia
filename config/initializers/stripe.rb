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
      content: "Vous avez réalisé une démarche pour résilier les comptes de #{order.deceased_first_name} #{order.deceased_last_name},
                nous vous tiendrons au courant des prochaines mises à jours sur ce panneau de notifications",
      order: order
    )

    doc_missing_count = order.order_documents.reject { |order_document| (order_document.document_file.attached? || order_document.document_input.present?) }.count

    if doc_missing_count >= 1
      Notification.create(
        content: "Vous n'avez pas fourni tous les documents nécessaires pour envoyer toutes les résiliations (il vous manque
        #{doc_missing_count} documents).",
        order: order
      )
    end
  end
end
