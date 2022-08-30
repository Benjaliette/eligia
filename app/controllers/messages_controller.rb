class MessagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.valid?
      MessageMailer.with(message: @message).contact.deliver_now
      redirect_to new_message_url
      flash[:success] = "Nous avons bien reçu votre message et nous vous répondrons le plus rapidement possible"
    else
      render :new, status: :unprocessable_entity
      flash[:alert] = "Il y a eu un problème dans votre demande de contact. S'il vous plait, réessayez."
    end
  end

  private

  def message_params
    params.require(:message).permit(:name, :email, :body)
  end
end
