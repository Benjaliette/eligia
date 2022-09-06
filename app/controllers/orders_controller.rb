require 'json'

class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[change new create edit update update_documents recap]

  before_action :set_order, only: %i[show change edit update update_documents recap success paiement]
  before_action :set_categories, only: %i[change new create]

  after_action :send_confirmation_mail, only: :success
  after_action :order_pundit, only: %i[show new change create edit update update_documents paiement recap success]

  def index
  end

  def show
    @order.update_order_account_status
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save && @order.order_accounts.count.positive?
      @order.generate_order_documents
      redirect_to edit_order_path(@order)
    else
      @order_accounts = @order.jsonify_order_accounts
      flash[:alert] = "Remplissez les champs nécessaires et sélectionnez au moins un contrat à résilier."
      render :new, status: :unprocessable_entity
    end
  end

  def change
    @order_accounts = @order.jsonify_order_accounts
    render :new
  end

  def update
    @order.clear_order_accounts(order_params)
    @order.update_order_account_status
    @order.generate_order_documents
    redirect_to edit_order_path(@order)
  end

  def edit
    @order_documents_json = @order.jsonify_order_documents
  end

  def update_documents
    @order.update(order_params) if params[:order]

    @order.update_order_account_status
    redirect_to recap_order_path(@order)
  end

  def recap
  end

  def paiement
    @order.pack = @order.determine_pack_type
    @order.amount = @order.pack.price
    @order.user = current_user

    if @order.save
      session = @order.set_stripe_paiement(success_order_url(@order), root_url)
      @order.update(checkout_session_id: session.id)

      redirect_to session.url, allow_other_host: true
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
    OrderMailer.with(order: @order, user: current_user).confirmation.deliver_now
  end
end
