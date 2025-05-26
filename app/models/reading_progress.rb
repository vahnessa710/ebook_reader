class ReadingProgress < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :chapter
  scope :for_user, ->(user) { where(user: user) }

  # validates :current_location, presence: true, 
  #                              numericality: { 
  #                                only_integer: true,
  #                                greater_than_or_equal_to: 0,
  #                                less_than_or_equal_to: 100 
  #                              }

  def current_chapter
    book.chapters.find_by(position: current_location.to_i)
  end

end
