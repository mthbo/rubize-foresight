class UserMailer < Devise::Mailer
  default from: 'contact@benoo-energies.com'
  layout 'mailer'

  def welcome
    @user = params[:user]
    @token = params[:token]
    mail(to: @user.email, subject: "Welcome to Rubize Foresight!")
  end
end
