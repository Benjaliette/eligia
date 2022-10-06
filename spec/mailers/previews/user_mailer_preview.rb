class UserMailerPreview < ActionMailer::Preview
  def welcome
    user = User.find(1)
    UserMailer.with(user: user).welcome
  end
end
