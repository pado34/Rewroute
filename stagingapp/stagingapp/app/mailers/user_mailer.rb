class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end  



  def payment_succeeded(user)
    @user = user
    @subb = Subscriber.find_by(user_id: @user.id)
    @plann = Plan.find_by(id: @subb.plan_id)
    mail to: user.email, subject: "Payment succeeded"
  end  

  def payment_failed(user)
    @user = user
    @subb = Subscriber.find_by(user_id: @user.id)
    @plann = Plan.find_by(id: @subb.plan_id)
    mail to: user.email, subject: "Payment failed"
  end  

end
