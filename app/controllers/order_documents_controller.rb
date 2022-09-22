class OrderDocumentsController < ApplicationController
  before_action :set_order_account, only: :update
  before_action :set_order_document, only: :update

  after_action :order_document_pundit, only: :update

  def update
    @orders = current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)
    @order_account.update_state
    @order_account.reload
    # @order_account.resiliation_file.download
    p "🚀yolo"
    if @order_document.update(order_document_params)
    p "✅ add doc"
      Notification.create(
        content: "Vous avez ajouté le document #{@order_document.document.name} pour la résiliation du
                  contrat #{@order_account.account.name}",
        order: @order_account.order
      )
      @order_document.rename_document_file
      @order_documents = @order_account.non_uploaded_order_documents
      redirect_to order_path(@order_account.order)
      flash[:alert] = "Document enregistré"
    else
      render order_account_order_documents_path(@order_account), status: :unprocessable_entity
    end
  end

  private

  def set_order_account
    @order_account = OrderAccount.find(params[:order_account_id])
  end

  def set_order_document
    @order_document = OrderDocument.find(params[:id])
  end

  def order_document_pundit
    authorize @order_document
  end

  def order_document_params
    params.require(:order_document).permit(:document_input, :document_file)
  end
end
