class BooksController < ApplicationController
    before_action :authenticate_user!

    def index
        @books = current_user.books.all
    end

    def show
        @book = Book.find(params[:id])
        @progress = @book.progress_percentage(current_user)
        @current_location = @book.current_location
        # @last_read_at = @book.last_read_at(current_user)
        # if user_signed_in?
        # @progress = current_user.reading_progresses.find_by(book: @book)
        #     if @progress&.current_chapter
        #         redirect_to book_chapter_path(@book, @progress.current_chapter)
        #         return
        #     end
        # end
        
        # redirect_to book_chapter_path(@book, @book.chapters.first)
    end
    
    def search_form; end

    def search
        @keywords  = params[:keywords]
        response = GutendexApi.get_book_by_keywords(@keywords)
        if response.success?
            @books = response.parsed_response['results']
            render :search_form
        else
            flash[:alert] = "Book not found or failed to fetch content."
            redirect_to search_form_books_path
        end
    end

    def create
        gutendex_id = params.dig(:book, :gutendex_id)

        response = GutendexApi.get_book_by_id(gutendex_id)

        if response.success?
            book_data = response.parsed_response
            download_url = book_data.dig("formats", "text/plain; charset=utf-8") || book_data.dig("formats", "text/plain; charset=us-ascii")
            cover_url = book_data.dig("formats", "image/jpeg")
            content = fetch_book_content(download_url)

            book = current_user.books.find_or_create_by!(gutendex_id: gutendex_id) do |book|
            book.title = book_data["title"]
            book.author = book_data["authors"]&.map { |a| a["name"] }&.join(", ")
            book.description = book_data["summaries"]&.first
            book.download_url = download_url
            book.content = content
            book.cover_url = cover_url
            end

            redirect_to books_path, notice: "Book added to your library!"
        else
            redirect_to search_form_books_path, alert: "Failed to fetch book data from Gutendex."
        end
    end

    # app/controllers/books_controller.rb
    def download
        book = Book.find(params[:id])
        # Fetch the file from the external URL
        response = HTTParty.get(book.download_url)
        
        send_data response.body,
                    filename: "#{book.title.parameterize}.epub", # or .pdf, etc.
                    type: response.content_type,
                    disposition: 'attachment'
    end

    private

    def set_book_id
        @book = User.books.find(params[:id])
    end

    def fetch_book_content(download_url)
        return nil unless download_url
        response = HTTParty.get(download_url)
        response.success? ? response.body : nil
    end
end
