class ChaptersController < ApplicationController
  
  def show
    @book = Book.find(params[:book_id])
    @chapter = @book.chapters.find(params[:id])
    @progress = current_user.reading_progresses.find_by(book: @book)
    @previous_chapter = @chapter.previous_chapter
    @next_chapter = @chapter.next_chapter
    @search_term = params.dig(:q, :cont)
      if @search_term.present?
        @search_results = search_in_content(@chapter.content, @search_term)
      end
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('search_results', partial: 'search_results')
      end
    end
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

  def search_in_content(content, term)
  return [] if term.blank?

  # Split by paragraphs or sentences as needed
  paragraphs = content.split(/\n|<p>|<\/p>/).reject(&:blank?)
  
  paragraphs.select do |paragraph|
    paragraph.downcase.include?(term.downcase)
  end
end
end