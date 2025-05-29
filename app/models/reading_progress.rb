class ReadingProgress < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :chapter
  scope :for_user, ->(user) { where(user: user) }
  
  def current_chapter
    book.chapters.find_by(position: current_location.to_i)
  end

end
