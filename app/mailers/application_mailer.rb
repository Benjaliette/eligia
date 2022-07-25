class ApplicationMailer < ActionMailer::Base
  before_action :add_attachment

  default from: "contact@eligia.fr"
  layout "mailer"

  private

  def add_attachment
    attachments.inline['eligia.svg'] = File.read('app/assets/images/eligia-sans-fond-vecto.svg')
  end
end
