class BooksController < ApplicationController
    before_action :set_book_id, only: %i[show destroy download]
    
    def index
        @books = current_user.books.all
    end

    def show
        @progress = current_user.reading_progresses.find_by(book: @book)
        if @progress&.current_location.present?
            @resume_chapter = @book.chapters.find_by(position: @progress.current_location)
        end
        @current_chapter = @resume_chapter || @book.chapters.order(:position).first
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
        
        if current_user.books.exists?(gutendex_id: gutendex_id)
            redirect_to search_form_books_path, alert: "Book is already in your library"
            return
        end

        response = GutendexApi.get_book_by_id(gutendex_id)

        if response.success?
            book_data = response.parsed_response
            download_url = book_data.dig("formats", "text/plain; charset=utf-8") || book_data.dig("formats", "text/plain; charset=us-ascii")
            cover_url = book_data.dig("formats", "image/jpeg")
            content = fetch_book_content(download_url)

            book = current_user.books.create!(
            gutendex_id: gutendex_id,
            title: book_data["title"],
            author: book_data["authors"]&.map { |a| a["name"] }&.join(", "),
            description: book_data["summaries"]&.first,
            download_url: download_url,
            content: content,
            cover_url: cover_url
            )

            redirect_to books_path, notice: "Book added to your library!"
        else
            redirect_to search_form_books_path, alert: "Failed to fetch book data from Gutendex."
        end
    end

    def destroy
        @book.destroy
        redirect_to books_path, notice: "Book was successfully removed from your library."
    end

    def download
        response = HTTParty.get(@book.download_url)
        
        send_data response.body,
                    filename: "#{@book.title.parameterize}.epub",
                    type: response.content_type,
                    disposition: 'attachment'
    end

    private

    def set_book_id
        @book = current_user.books.find(params[:id])
    end

    def fetch_book_content(download_url)
        return nil unless download_url
        response = HTTParty.get(download_url)
        response.success? ? response.body : nil
    end
end
