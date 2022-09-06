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
    update_order_account_status(@order)
  end

  def new
    @order = Order.new
    @categories = Category.all
  end

  def create
    @categories = Category.all
    @order = Order.new(order_params)
    @order.pack = @order.determine_pack_type
    @order.amount = @order.pack.price

    if @order.save && @order.order_accounts.count.positive?
      generate_order_documents
      redirect_to edit_order_path(@order)
    else
      @order_accounts = jsonify_order_accounts
      flash[:alert] = "Remplissez les champs nécessaires et sélectionnez au moins un contrat à résilier."
      render :new, status: :unprocessable_entity
    end
  end

  def change
    @order_accounts = jsonify_order_accounts
    render :new
  end

  def update
    order_accounts = @order.clear_order_accounts(order_params)
    update_order_account_status(@order)
    generate_order_documents
    redirect_to edit_order_path(@order)
  end

  def edit
    @order_documents_json = jsonify_order_documents
  end

  def update_documents
    @order.update(order_params) if params[:order]

    update_order_account_status(@order)
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

  def jsonify_order_accounts
    accounts = @order.order_accounts.map do |order_account|
      {
        account_id: order_account.account.id,
        account_valid: order_account.account.status,
        account_name: order_account.account.name.gsub(' ', '_'),
        account_subcategory: order_account.account.subcategory.id
      }
    end

    JSON.generate({ accounts: })
  end

  def jsonify_order_documents
    documents = @order.order_documents.map do |order_document|
      {
        document: order_document.document_file.attached?
      }
    end

    JSON.generate({ documents: })
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

  def generate_order_documents
    # raise
    @order.order_documents.map(&:delete) unless @order.order_documents.empty?
    @order.required_documents.each do |required_document|
      OrderDocument.create(order: @order, document: required_document) if @order.order_documents.none? { |order_document| (order_document.document == required_document) && (!order_document.frozen?) }
    end
  end

  def update_order_account_status(order)
    order.order_accounts.each do |order_account|
      order_account.declare_pending! if order_account.order_documents.all? { |order_document| (order_document.document_file.attached? || order_document.document_input.present?) }
    end
  end

  def send_confirmation_mail
    OrderMailer.with(order: @order, user: current_user).confirmation.deliver_now
  end
end
