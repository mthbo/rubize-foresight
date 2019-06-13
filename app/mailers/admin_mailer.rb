class AdminMailer < Devise::Mailer
  default from: 'contact@benoo-energies.com'
  layout 'mailer'

  def new_user_waiting_for_approval(email)
    @email = email
    mail(to: 'mbordeleau@benoo-energies.com', subject: 'New User Awaiting Admin Approval')
  end
end
