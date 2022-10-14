class OrderDocumentsController < ApplicationController
  before_action :set_order_account, only: :update
  before_action :set_order_document, only: %i[update update_documents]
  before_action :set_order, only: %i[update update_documents]
  before_action :set_orders, only: %i[update update_documents]

  after_action :order_document_pundit, only: %i[update update_documents]

  def update
    if @order_document.update(order_document_params) && not_empty?(@order_document)
      notify_user
      @order_documents = @order_account.order_documents
      @order_account.update_state
      @order.update_state
      flash.now[:alert] = "Document enregistré"
      respond_to { |format| format.turbo_stream }
      end
    else
      render turbo_stream: turbo_stream.update("#{@order_account.id}-#{@order_document.id}", partial: "shared/error_messages",
        locals: { error: @order_document.errors[:document_input].first })
    end
  end

  def update_documents
    if @order_document.update(order_document_params) && not_empty?(@order_document)
      @order_documents = @order.order_documents
      @order.order_accounts.each { |order_account| order_account.update_state }
      flash.now[:alert] = "Document enregistré"
      respond_to { |format| format.turbo_stream }
    else
      render turbo_stream: turbo_stream.update(@order_document, partial: "shared/error_messages",
          locals: { error: @order_document.errors[:document_input].first })
    end
  end

  private

  def set_order_account
    @order_account = OrderAccount.find(params[:order_account_id])
  end

  def set_order_document
    @order_document = OrderDocument.find(params[:id])
  end

  def set_order
    @order = Order.friendly.find(params[:order_id])
  end

  def set_orders
    @orders = current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)
  end

  def order_document_pundit
    authorize @order_document
  end

  def order_document_params
    params.require(:order_document).permit(:document_input, :document_file)
  end

  def not_empty?(order_document)
    @order_document.document_input != "" || @order_document.document_file.attached?
  end

  def notify_user
    Notification.create(
      content: "Le document/information #{@order_document.document.name} a été ajouté pour votre démarche
                concernant #{@order.deceased_first_name} #{@order.deceased_last_name}",
      order: @order,
      order_account: @order_account ? @order_account : nil
    )
  end
end
