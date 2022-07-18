class MessageMailerPreview < ActionMailer::Preview
  def contact
    message = Message.new(name: "preview", mail: "preview@mail.com", body: "Test")
    MessageMailer.with(message: message).contact
  end
end
