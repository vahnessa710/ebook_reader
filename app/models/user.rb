class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable 

  has_many :books
  has_many :vocabularies, dependent: :destroy 
  has_many :reading_progresses
  has_many :notes, dependent: :destroy


end
