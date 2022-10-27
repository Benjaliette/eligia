require 'json'

class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new created edit update update_documents recap destroy webhook]
  skip_before_action :verify_authenticity_token, only: :webhook

  before_action :set_order, only: %i[show created edit update update_documents recap success paiement destroy]
  before_action :set_categories, only: %i[created update]

  after_action :send_confirmation_mail, only: :webhook
  after_action :order_pundit, only: %i[show new created edit update update_documents paiement recap success destroy webhook]

  def index
  end

  def show
    @orders = current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)
    @order.update_order_account_status
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

    if @order.save
      payment = @order.set_mollie_payment(success_order_url(@order), mollie_webhook_url)
      @order.update(checkout_session_id: payment.id)

      redirect_to payment._links.dig("checkout", "href"), allow_other_host: true
    else
      render :recap
    end
  end

  def success
  end

  def webhook
    payment = Mollie::Payment.get(params[:id])
    return unless payment.paid?

    @order = Order.find_by(checkout_session_id: payment.id)
    @order.update(paid: true)
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
      order_accounts_attributes: [
        :id,
        :account_id,
        account_attributes: [
          :_destroy,
          :name,
          :subcategory_id
        ]
      ],
      order_documents_attributes: [
        :id,
        :document_id,
        :document_file,
        :document_input
      ]
    )
  end

  def send_confirmation_mail
    OrderMailer.with(order: @order, user: @order.user).confirmation.deliver_now
    OrderMailer.with(order: @order, user: @order.user).notification_to_contact.deliver_now
  end
end
