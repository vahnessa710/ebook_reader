class UserMailer < ApplicationMailer
  default from: 'avionbatch38.stockapp@gmail.com'
  
  def registration_success(user)
    @user = user
    mail(to: @user.email, subject: 'Registration Successful')
  end

end