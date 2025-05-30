class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :books
  has_many :vocabularies
  has_many :reading_progresses
  has_many :notes, dependent: :destroy
end
