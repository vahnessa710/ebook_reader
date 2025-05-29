class Chapter < ApplicationRecord
  belongs_to :book
  has_many :reading_progresses, dependent: :destroy

  # Default scope to always order chapters by position
  default_scope { order(position: :asc) }

  def previous_chapter
    book.chapters.where("position < ?", position).order(position: :desc).first
  end
  
  def next_chapter
    book.chapters.where("position > ?", position).order(position: :asc).first
  end

  def ordered_for_book(book)
    book.chapters.order(:position)
  end

  def user_progress_percentage(user) #fetch user reading progress
    progress = user.reading_progresses.find_by(book: book)
    progress&.progress_percentage || 0
  end

  def progress_percentage # calculate chapter's position based progress
    return 0 if book.nil? || book.chapters.empty?
    (position.to_f / book.chapters.count * 100).round(2)
  end
end
