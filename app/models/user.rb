class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :books
  has_many :vocabularies
  has_many :reading_progresses
  has_many :notes, dependent: :destroy

  THEMES = {
    light: 0,
    dark: 1
  }.freeze

  def theme_name
    THEMES.key(theme) || :light
  end

  def dark_theme?
    theme == THEMES[:dark]
  end
end
