class Book < ApplicationRecord
    belongs_to :user
    has_many :reading_progresses
    has_many :chapters, dependent: :destroy
    after_create :fetch_content_and_parse_chapters

     # Calculate progress percentage (0-100)
    def progress_percentage(user = nil)
        return 0 if chapters.empty?

        if user
            # For a specific user's progress
            progress = reading_progresses.find_by(user: user)
            current_location = progress&.current_location || 0
        end

        ((current_location.to_f / chapters.count) * 100).round(2)
    end

    def current_location
        progress = reading_progresses.find_by(user: user)
        current_location = progress&.current_location
    end

    #  def last_read_at(user)
    #     book.reading_progresses&.last_read_at
    # end

    private

    def fetch_content_and_parse_chapters
        raw_content = GutendexApi.get_book_content(self.gutendex_id)
        return if raw_content.blank?
        
        self.update(content: raw_content)
        parsed_text = ActionView::Base.full_sanitizer.sanitize(raw_content)
        ChapterParser.new(self, parsed_text).parse
    end

    def find_or_create_book(book_id)
        book_data = response.parsed_response
        download_url = book_data.dig("formats", "text/plain; charset=utf-8") || book_data.dig("formats", "text/plain; charset=us-ascii")
        cover_url = book_data.dig("formats", "image/jpeg")
        content = fetch_book_content(download_url)

        book = User.books.find_or_create_by!(gutendex_id: gutendex_id) do |book|
                book.title = book_data["title"]
                book.author = book_data["authors"]&.map { |a| a["name"] }&.join(", ")
                book.description = book_data["summaries"]&.first
                book.download_url = download_url
                book.content = content
                book.cover_url = cover_url
        end
    end
end
