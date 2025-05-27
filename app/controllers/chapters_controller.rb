class ChaptersController < ApplicationController
  
  def show
    @book = Book.find(params[:book_id])
    @chapter = @book.chapters.find(params[:id])
    # Calculate progress metrics
    
    total_chapters = @book.chapters.count #total chapters of the book

    @progress = current_user.reading_progresses.find_by(book: @book)
    
    # Only update progress if coming from chapter list navigation
    if params[:from_navigation]
      update_reading_progress(
        chapter_position: @chapter.position,
        progress_percentage: @chapter.progress_percentage
      )
    end

    @previous_chapter = @chapter.previous_chapter
    @next_chapter = @chapter.next_chapter
  end


  private

  def update_reading_progress(chapter_position:, progress_percentage:)
    progress = current_user.reading_progresses.find_or_initialize_by(book: @book)
    
    progress.assign_attributes(
      chapter: @chapter,
      current_location: chapter_position,  # Stores raw chapter position (e.g., 3)
      progress_percentage: progress_percentage,  # Stores calculated percentage
      last_read_at: Time.current
    )
    
    progress.save!
  end
end