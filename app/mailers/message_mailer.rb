class MessageMailer < ApplicationMailer
  def contact
    @message = params[:message]

    unless @message.attachments.nil?
      unless @message.attachments.empty?
        @message.attachments.each do |attachment|
          attachments[attachment.original_filename] = File.read(attachment)
        end
      end
    end

    mail to: "contact@eligia.fr", subject: "Nouvelle demande de contact de #{@message.name}"
  end
end
