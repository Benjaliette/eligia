class UserMailerPreview < ActionMailer::Preview
  def welcome
    user = User.find(2)
    UserMailer.with(user: user).welcome
  end
end
