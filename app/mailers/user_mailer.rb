class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    attachments.inline['eligia.svg'] = File.read('app/assets/images/eligia-sans-fond-vecto.svg')

    mail to: @user.email, subject: "Confirmation de votre inscription à Eligia"
  end
end
