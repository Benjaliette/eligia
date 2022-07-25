class OrderMailer < ApplicationMailer
  def confirmation
    @user = params[:user]
    @order = params[:order]

    mail to: @user.email, subject: "Confirmation de votre commande chez Eligia"
  end
end
