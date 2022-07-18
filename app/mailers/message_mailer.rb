class MessageMailer < ApplicationMailer
  def contact
    @message = params[:message]

    mail to: "contact@eligia.fr", subject: "Nouvelle demande de contact de #{@message.name}"
  end
end
