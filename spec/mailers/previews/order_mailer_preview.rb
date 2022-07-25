class OrderMailerPreview < ActionMailer::Preview
  def confirmation
    @user = User.find(2)
    @order = @user.orders.last
    OrderMailer.with(user: @user, order: @order).confirmation
  end
end
