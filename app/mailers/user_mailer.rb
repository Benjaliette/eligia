class UserMailer < ApplicationMailer

  def welcome
    @user = params[:user]

    mail to: @user.email, subject: "Confirmation de votre inscription à Eligia"
  end
end
