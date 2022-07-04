class OrdersController < ApplicationController
  before_action :set_order, only: %i[show paiement edit update]
  before_action only: :paiement do
    open_paiement_session(@order)
  end

  def show
  end

  def new
    @order = Order.new
    @categories = Category.all
  end

  def create
    @categories = Category.all
    @order = Order.new(order_params)
    @order.user = current_user
    @order.pack = @order.determine_pack_type
    @order.amount = @order.pack.price

    if @order.save
      redirect_to add_documents_order_path(@order)
    else
      render :new
    end
  end

  def edit
    @order_documents = []
    @order.required_documents.each do |required_document|
      @order_documents << OrderDocument.create(order: @order, document: required_document)
    end
  end

  def update
    @order.update(order_params)
    if @order.save
      redirect_to paiement_order_path(@order)
    else
      render :edit
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
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
          :category_id
        ]
      ],
      order_documents_attributes: [
        :id,
        :document_id,
        :document_file
      ]
    )
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def open_paiement_session(order)
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: "Vous avez choisi la formule #{order.pack.title}",
        amount: order.amount_cents,
        currency: 'eur',
        quantity: 1
      }],
      success_url: order_url(order),
      cancel_url: order_url(order)
    )
    order.update(checkout_session_id: session.id)
  end
end
