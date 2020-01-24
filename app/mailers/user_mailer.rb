class UserMailer < Devise::Mailer
  default from: 'contact@benoo-energies.com'
  layout 'mailer'

  def welcome
    @user = params[:user]
    @token = params[:token]
    mail(to: @user.email, subject: "Welcome to Rubize Foresight!")
  end

  def request_registration
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    mail(to: params[:user].email, subject: "New request on Rubize Foresight")
  end
end
