class Vocabulary < ApplicationRecord
  belongs_to :user

  validates :word, presence: true, uniqueness: true
  validates :definition, presence: true
  
end
