require 'json'

class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new created edit update update_documents recap destroy]

  before_action :set_order, only: %i[show created edit update update_documents recap paiement destroy success show_invoice_pdf]
  before_action :set_categories, only: %i[created update]

  after_action :declare_paid, only: :success
  after_action :order_pundit, only: %i[show new created edit update update_documents paiement recap success destroy show_invoice_pdf]

  def index
  end

  def show
    @orders = current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)
    @order.update_order_account_status
  end

  def show_invoice_pdf
    pdf = OrderPdf.new(@order)
    pdf.prawn_invoice
    send_data pdf.render,
              filename: "export.pdf",
              type: 'application/pdf',
              disposition: 'inline' # Pour ouvrir et ne pas télécharger

    authorize @order
  end

  def new
    @order = Order.create
    redirect_to created_order_path(@order)
  end

  def created
    @accounts = Account.all
  end

  def update
    if @order.order_accounts.count.positive?
      @order.generate_order_documents
      @order.update_order_account_status
      redirect_to edit_order_path(@order)
    else
      flash[:alert] = "Veuillez sélectionner au moins un contrat à résilier."
      render :created, status: :unprocessable_entity
    end
  end

  def edit
    @order_documents_json = @order.jsonify_order_documents
    @order_text_documents = @order.order_documents.select { |od| od.document.format == 'text' }
    @order_file_documents = @order.order_documents.select { |od| od.document.format == 'file' }
  end

  def update_documents
    @order_text_documents = @order.order_documents.select { |od| od.document.format == 'text' }
    @order_file_documents = @order.order_documents.select { |od| od.document.format == 'file' }

    if @order.update(order_params) && params[:order]
      @order.update_order_account_status
      redirect_to recap_order_path(@order)
    else
      render :edit
    end
  end

  def destroy
    @order.destroy

    redirect_to root_path
  end

  def recap
  end

  def paiement
    @order.pack = @order.determine_pack_type
    @order.amount = @order.pack.price
    @order.user = current_user
    if @order.update(order_params)
      payment = @order.set_payplug_payment
      @order.update(checkout_session_id: payment[:id])

      redirect_to payment[:hosted_payment][:payment_url], allow_other_host: true
    else
      render :recap
    end
  end

  def success
  end

  private

  def set_order
    @order = Order.friendly.find(params[:id])
  end

  def set_categories
    @categories = Category.all
  end

  def order_pundit
    authorize @order
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

  def send_confirmation_mail
    return unless @order

    OrderMailer.with(order: @order, user: @order.user).confirmation.deliver_now
    OrderMailer.with(order: @order, user: @order.user).notification_to_contact.deliver_now
  end

  def declare_paid
    @order.notify_order_payment
    @order.update(paid: true)
    @order.attach_invoice_pdf unless Rails.env == 'test'
    send_confirmation_mail
  end
end
