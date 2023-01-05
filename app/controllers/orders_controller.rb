class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create edit update show destroy]

  before_action :set_order, only: %i[show edit update destroy success show_invoice_pdf]
  before_action :set_categories, only: %i[new create edit update]
  before_action :set_accounts, only: %i[new create edit]

  after_action :order_pundit, only: %i[show new create edit update show_invoice_pdf destroy]

  def show
  end

  def show_invoice_pdf
    pdf = OrderPdf.new(@order)
    pdf.prawn_invoice
    send_data pdf.render,
              filename: "export.pdf",
              type: 'application/pdf',
              disposition: 'inline' # Pour ouvrir et ne pas télécharger

    authorize @order
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to edit_order_path(@order)
      send_order_creation_email
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @order.order_accounts.count.positive?
      @order.generate_order_documents
      @order.update_order_account_status
      redirect_to edit_documents_order_path(@order)
    else
      flash[:alert] = "Veuillez sélectionner au moins un contrat à résilier."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy

    redirect_to root_path
  end

  private

  def set_order
    @order = Order.friendly.find(params[:id]).decorate
  end

  def set_categories
    @categories = Category.all
  end

  def set_accounts
    @accounts = Account.all
  end

  def order_pundit
    authorize @order
  end

  def send_order_creation_email
    return if Rails.env == "test"

    OrderMailer.with(order: @order).order_creation.deliver_now
  end

  def order_params
    params.require(:order).permit(
      :deceased_first_name,
      :deceased_last_name,
      :user_email,
      order_documents_attributes: [
        :id,
        :document_id,
        :document_file,
        :document_input
      ],
      address_attributes: [
        :id,
        :street,
        :complement,
        :zip,
        :state,
        :city
      ]
    )
  end
end
