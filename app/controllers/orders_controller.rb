class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update recap]
  before_action only: :show do
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
      @order_documents = []
      @order.required_documents.each do |required_document|
        @order_documents << OrderDocument.create(order: @order, document: required_document)
      end

      redirect_to edit_order_path(@order)
    else
      flash[:alert] = "Attention, il manque des informations"
      render :new
    end
  end

  def edit
    @order_documents = @order.order_documents
  end

  def update
    @order.update(order_params)
    if @order.save
      update_order_account_status(@order)
      redirect_to recap_order_path(@order)
    else
      render :edit
    end
  end

  def recap
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
          :subcategory_id
        ]
      ],
      order_documents_attributes: [
        :id,
        :document_id,
        :document_file
      ]
    )
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

  def update_order_account_status(order)
    order.order_accounts.each do |order_account|
      if order_account.order_documents.map { |o_d| o_d.document_file.attached? }.uniq == [true]
        order_account.declare_pending!
      end
    end
  end
end
