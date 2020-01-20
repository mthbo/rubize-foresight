class UserMailer < Devise::Mailer
  default from: 'contact@benoo-energies.com'
  layout 'mailer'

  def user_welcome_email(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: "Welcome to Rubize Foresight!")
  end
end
