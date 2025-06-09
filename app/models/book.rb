class Book < ApplicationRecord
    belongs_to :user
    has_many :reading_progresses
    has_many :chapters, dependent: :destroy
    after_create :fetch_content_and_parse_chapters

    def progress_percentage(user = nil)
        return 0 if chapters.empty?
        if user
            progress = reading_progresses.find_by(user: user)
            current_location = progress&.current_location || 0
        end

        ((current_location.to_f / chapters.count) * 100).round(2)
    end

    def current_location
        progress = reading_progresses.find_by(user: user)
        current_location = progress&.current_location
    end

    def last_read_at_for(user)
        reading_progresses.find_by(user: user)&.last_read_at
    end

    private

    def fetch_content_and_parse_chapters
        raw_content = GutendexApi.get_book_content(self.gutendex_id)
        return if raw_content.blank?
        
        self.update(content: raw_content)
        parsed_text = ActionView::Base.full_sanitizer.sanitize(raw_content)
        ChapterParser.new(self, parsed_text).parse
    end
end
