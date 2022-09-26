class OrderDocumentsController < ApplicationController
  before_action :set_order_account, only: :update
  before_action :set_order_document, only: %i[update update_documents]
  before_action :set_order, only: %i[update update_documents]

  after_action :order_document_pundit, only: %i[update update_documents]

  def update
    @orders = current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)
    @order_account.update_state
    @order_account.reload
    if @order_document.update(order_document_params)
      Notification.create(
        content: "Vous avez ajouté le document #{@order_document.document.name} pour la résiliation du
                  contrat #{@order_account.account.name} de #{@order_account.order.deceased_first_name} #{@order_account.order.deceased_last_name}",
        order: @order,
        order_account: @order_account
      )
      @order_documents = @order_account.order_documents
      redirect_to order_path(@order_account.order)
      flash[:alert] = "Document enregistré"
    else
      render order_order_account_order_document_path(@order, @order_account, @order_document), status: :unprocessable_entity
    end
  end

  def update_documents
    @orders = current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)
    @order.order_accounts.each do |oa|
      oa.update_state
      oa.reload
    end
    if @order_document.update(order_document_params)
      Notification.create(
        content: "Vous avez ajouté le document #{@order_document.document.name} pour votre démarche
                 concernant #{@order.deceased_first_name} #{@order.deceased_last_name}",
        order: @order,
      )
      @order_documents = @order.order_documents
      redirect_to order_path(@order)
      flash[:alert] = "Document enregistré"
    else
      render order_order_document_path(@order, @order_document), status: :unprocessable_entity
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

  def order_document_pundit
    authorize @order_document
  end

  def order_document_params
    params.require(:order_document).permit(:document_input, :document_file)
  end
end
