class DeviseMailer < Devise::Mailer
  layout "mailer"

  def confirmation_instructions(record, opts={})
    @mail = super
    mail to: record.email, subject: "Eligia - Nous avons besoin de votre confirmation"
  end

  def reset_password_instructions(record, token, opts={})
    @mail = super
    mail to: record.email, subject: "Eligia - Changement de votre mot de passe"
  end
end
