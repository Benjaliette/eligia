require 'json'

class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[change new create edit update recap]

  before_action :set_order, only: %i[show change edit update recap success paiement]
  before_action :set_categories, only: %i[change new create]
  after_action :send_confirmation_mail, only: :success

  add_breadcrumb "1. Résiliations", :change_order_path, only: %i[edit recap]
  add_breadcrumb "2. Informations nécessaires", :edit_order_path, only: :recap

  add_breadcrumb "Démarches", :user_path, only: :show

  def index
  end

  def show
    add_breadcrumb "#{@order.deceased_last_name.capitalize}-#{@order.deceased_first_name.first}"
  end


  def new
    @order = Order.new
    @categories = Category.all
  end

  def change
    @order_accounts = jsonify_order_accounts

    add_breadcrumb "<div class='current-step'>1. Résiliations</div>".html_safe
    add_breadcrumb "2. Informations nécessaires"
    add_breadcrumb "3. Validation"

    render :new
  end

  def create
    @categories = Category.all

    @order = Order.new(order_params)
    @order.pack = @order.determine_pack_type
    @order.amount = @order.pack.price

    if @order.save
      set_order_documents_to_order

      redirect_to edit_order_path(@order)
    else
      flash[:alert] = "Attention, il manque des informations"
      render :new
    end
  end

  def edit
    set_order_documents_to_order

    @order_documents = @order.order_documents
    @order_documents_json = jsonify_order_documents

    add_breadcrumb "<div class='current-step'>2. Informations nécessaires</div>".html_safe
    add_breadcrumb "3. Validation"
  end

  def update
    @order.update(order_params)
    update_order_account_status(@order)

    redirect_to recap_order_path(@order)
  end

  def recap
    add_breadcrumb "<div class='current-step'>3. Validation</div>".html_safe
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
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @customer = Stripe::Customer.retrieve(session.customer)

    @order.user.add_adress!(@customer.address)
  end

  private

  def set_order
    @order = Order.friendly.find(params[:id])
  end

  def set_categories
    @categories = Category.all
  end

  def jsonify_order_accounts
    accounts = @order.order_accounts.map do |order_account|
      {
        account_id: order_account.account.id,
        account_name: order_account.account.name.gsub(' ', '_'),
        account_subcategory: order_account.account.subcategory.id,
      }
    end

    JSON.generate({ accounts: accounts })
  end

  def jsonify_order_documents
    documents = @order_documents.map do |order_document|
      {
        document: order_document.document_file.attached?,
      }
    end

    JSON.generate({ documents: documents })
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

  def set_order_documents_to_order
    @order.required_documents.each do |required_document|
      OrderDocument.create(order: @order, document: required_document) if @order.order_documents.none? do |order_document|
        order_document.document == required_document
      end
    end
  end

  def update_order_account_status(order)
    order.order_accounts.each do |order_account|
      order_account.declare_pending! if order_account.order_documents.all? { |o_d| o_d.document_file.attached? }
    end
  end

  def send_confirmation_mail
    OrderMailer.with(order: @order, user: current_user).confirmation.deliver_now
  end
end
