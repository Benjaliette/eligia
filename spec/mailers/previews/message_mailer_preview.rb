class MessageMailerPreview < ActionMailer::Preview
  def contact
    message = Message.new(name: "preview", email: "preview@mail.com", body: "Test")
    MessageMailer.with(message: message).contact
  end
end
