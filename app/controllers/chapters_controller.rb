class ChaptersController < ApplicationController
  def show
    @book = Book.find(params[:book_id])
    @chapter = @book.chapters.find(params[:id])
    @progress = current_user.reading_progresses.find_by(book: @book)
    @previous_chapter = @chapter.previous_chapter
    @next_chapter = @chapter.next_chapter
  end

  def update_progress
    @book = Book.find(params[:book_id])
    @chapter = @book.chapters.find(params[:id])
    
    update_reading_progress(
      chapter_position: @chapter.position,
      progress_percentage: @chapter.progress_percentage
    )
    
    head :ok
  end

  private

  def update_reading_progress(chapter_position:, progress_percentage:)
    progress = current_user.reading_progresses.find_or_initialize_by(book: @book)
    
    progress.assign_attributes(
      chapter: @chapter,
      current_location: chapter_position,
      progress_percentage: progress_percentage,
      last_read_at: Time.current
    )
    
    progress.save!
  end
end