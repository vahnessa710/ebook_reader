<<<<<<< HEAD
class Vocabulary < ApplicationRecord
  belongs_to :user

  validates :word, presence: true
  validates :definition, presence: true
  
end
=======
class Vocabulary < ApplicationRecord
  belongs_to :user
  validates :word, presence: true
  validates :definition, presence: true
end
>>>>>>> origin/book_branch_2
