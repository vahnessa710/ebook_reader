class BooksController < ApplicationController

    def index
        @response = WebsterApi.get_word(@word)
        @word = "computer"
        @definition = WebsterApi.get_definition(@word)
    end

    def show
        id = '84'
        @book = GutendexApi.get_book(id)
        @content = GutendexApi.get_book_content(id)
    end
end
