require 'json'

class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create edit update show destroy]

  before_action :set_order, only: %i[show edit update update_documents recap paiement destroy success show_invoice_pdf]
  before_action :set_categories, only: %i[edit update]

  after_action :declare_paid, only: :success

  after_action :order_pundit, only: %i[show new create edit update paiement recap success destroy show_invoice_pdf]

  def index
  end

  def show
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

  def create
    @order = Order.create
    redirect_to edit_order_path(@order)
  end

  def edit
    @accounts = Account.all
  end

  def update
    if @order.order_accounts.count.positive?
      @order.generate_order_documents
      @order.update_order_account_status
      redirect_to edit_documents_order_path(@order)
    else
      flash[:alert] = "Veuillez sélectionner au moins un contrat à résilier."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy

    redirect_to root_path
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
end
