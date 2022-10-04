class OrderMailerPreview < ActionMailer::Preview
  def confirmation
    @user = User.find(1)
    @order = @user.orders.last
    OrderMailer.with(user: @user, order: @order).confirmation
  end
end
