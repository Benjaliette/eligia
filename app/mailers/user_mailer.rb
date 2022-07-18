class UserMailer < ApplicationMailer

  def welcome
    @user = params[:user]
    @greeting = "Hi"

    mail to: @user.email, subject: "Confirmation de votre inscription à Eligia"
  end
end
