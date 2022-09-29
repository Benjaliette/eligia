class OrderMailer < ApplicationMailer
  def confirmation
    @user = params[:user]
    @order = params[:order]

    mail to: @user.email, subject: "Eligia - Confirmation de votre demande de résiliation"
  end

  def notification_to_contact
    @user = params[:user]
    @order = params[:order]

    mail to: "contact@eligia.fr", subject: "Nouvelle commande de #{@user.first_name} #{@user.last_name}"
  end
end
