class OrderMailer < ApplicationMailer
  def confirmation
    @user = params[:user]
    @order = params[:order]

    mail to: @user.email, subject: "Eligia - Confirmation de votre demande de résiliation"
  end
end
