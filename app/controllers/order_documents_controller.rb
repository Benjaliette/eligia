class OrderDocumentsController < ApplicationController
  before_action :set_order_account, only: :update
  before_action :set_order_document, only: %i[update update_documents]
  before_action :set_order, only: %i[update update_documents]

  after_action :order_document_pundit, only: %i[update update_documents]

  def update
    @orders = current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)
    if @order_document.update(order_document_params) && (@order_document.document_input != "" || @order_document.document_file.attached?)
      Notification.create(
        content: "Vous avez ajouté le document #{@order_document.document.name} pour la résiliation du
                  contrat #{@order_account.account.name} de #{@order_account.order.deceased_first_name} #{@order_account.order.deceased_last_name}",
        order: @order,
        order_account: @order_account
      )
      @order_documents = @order_account.order_documents
      @order_account.update_state
      @order.update_state
      flash.now[:alert] = "Document enregistré"
      render turbo_stream: [
        turbo_stream.update("flash", partial: "shared/flash"),
        turbo_stream.update("docs-#{@order.id}", partial: 'shared/order_document_input_card',
                                                 locals: {
                                                    order_documents_to_add: @order.non_uploaded_order_documents,
                                                    order_account: false,
                                                    no_doc_message: '',
                                                    modal_height: ''
                                                  }),
        turbo_stream.update("order-state", @order.state_to_french),
        turbo_stream.update("modal-#{@order_account.id}", partial: 'shared/order_document_input_card',
                                                          locals: {
                                                            order_documents_to_add: @order_account.non_uploaded_order_documents,
                                                            order_account: @order_account,
                                                            no_doc_message: 'Vous avez ajouté toutes les informations nécessaires',
                                                            modal_height: 'modal-height'
                                                          })
      ]

    else
      render turbo_stream: turbo_stream.update("#{@order_account.id}-#{@order_document.id}", partial: "shared/error_messages",
        locals: { error: @order_document.errors[:document_input].first })
    end
  end

  def update_documents
    @orders = current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)

    if @order_document.update(order_document_params) && (@order_document.document_input != "" || @order_document.document_file.attached?)
      Notification.create(
        content: "Vous avez ajouté le document #{@order_document.document.name} pour votre démarche
                 concernant #{@order.deceased_first_name} #{@order.deceased_last_name}",
        order: @order
      )
      @order_documents = @order.order_documents
      @order.order_accounts.each { |order_account| order_account.update_state }
      flash.now[:alert] = "Document enregistré"
      render turbo_stream: [
        turbo_stream.update("flash", partial: "shared/flash"),
        turbo_stream.update("docs-#{@order.id}", partial: 'shared/order_document_input_card',
                                                 locals: {
                                                   order_documents_to_add: @order.non_uploaded_order_documents,
                                                   order_account: false,
                                                   no_doc_message: '',
                                                   modal_height: ''
                                                 }),
        turbo_stream.update("oa-cards-#{@order.id}", partial: "orders/order_account_cards", locals: { order: @order }),
        turbo_stream.update("order-state", @order.state_to_french)
      ]
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

  def order_document_pundit
    authorize @order_document
  end

  def order_document_params
    params.require(:order_document).permit(:document_input, :document_file)
  end
end
