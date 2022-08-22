class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]

    mail to: @user.email, subject: "Eligia - Confirmation de votre inscription"
  end
end
