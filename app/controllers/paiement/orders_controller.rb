class Paiement::OrdersController < ApplicationController
  before_action :set_order, only: %i[update show]
  before_action :declare_paid, only: :show
  after_action :order_pundit, only: %i[update show]

  def show
  end

  def update
    @order.pack = @order.determine_pack_type
    @order.amount = @order.pack.price
    @order.user = current_user
    if @order.update(order_params)
      payment = @order.set_payplug_payment
      @order.update(checkout_session_id: payment[:id])

      redirect_to payment[:hosted_payment][:payment_url], allow_other_host: true
    else
      render 'orders/show'
    end
  end

  private

  def declare_paid
    return unless @order.payplug_is_paid?

    @order.notify_order_payment
    @order.update(paid: true)
    @order.attach_invoice_pdf unless Rails.env == 'test'
    send_confirmation_mail
  end

  def send_confirmation_mail
    return unless @order

    OrderMailer.with(order: @order, user: @order.user).confirmation.deliver_now
    OrderMailer.with(order: @order, user: @order.user).notification_to_contact.deliver_now
  end

  def order_params
    params.require(:order).permit(
      :deceased_first_name,
      :deceased_last_name,
      order_documents_attributes: [
        :id,
        :document_id,
        :document_file,
        :document_input
      ],
      address_attributes: [
        :id,
        :street,
        :complement,
        :zip,
        :state,
        :city
      ]
    )
  end

  def set_order
    @order = Order.friendly.find(params[:id]).decorate
  end

  def order_pundit
    authorize [:paiement, @order]
  end
end
