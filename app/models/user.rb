class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :vocabularies
  has_many :reading_progresses

  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.registration_success(self).deliver_now
  end


end
