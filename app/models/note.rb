class Note < ApplicationRecord
  belongs_to :user
<<<<<<< HEAD

  
  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 1000 }
  
=======
>>>>>>> origin/book_branch_2
end
