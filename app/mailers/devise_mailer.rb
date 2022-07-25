class DeviseMailer < Devise::Mailer
  def confirmation_instructions(record, opts={})
    @mail = super
    mail to: record.email, subject: "Nous avons besoin de votre confirmation"
  end

  def reset_password_instructions(record, opts={})
    @mail = super
    mail to: record.email, subject: "Changement de votre mot de passe"
  end
end
