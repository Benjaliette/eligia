class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
    @categories = Category.all
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user
    @order.pack = determine_pack_type(@order.order_accounts)
    @order.amount_cents = @order.pack.price_cents
    if @order.save!
      open_paiement_session(@order)
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  def paiement
    @order = Order.find(params[:id])
  end

  private

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
      ]
    )
  end

  def determine_pack_type(number_of_account)
    case number_of_account.size
    when 1..5 then return Pack.find(1)
    when 6..10 then return Pack.find(2)
    when 10..14 then return Pack.find(3)
    when 15..20 then return Pack.find(4)
    else
      return 'error'
    end
  end

  def open_paiement_session(order)
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: order.pack.title,
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
