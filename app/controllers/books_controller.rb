class BooksController < ApplicationController
    def show
        id = '84'
        @book = GutendexApi.get_book(id)
        @content = GutendexApi.get_book_content(id)
    end
end
