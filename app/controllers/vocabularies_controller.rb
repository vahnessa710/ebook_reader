class VocabulariesController < ApplicationController

    def index
        @response = WebsterApi.get_word(@word)
        @word = "computer"
        @definition = WebsterApi.get_definition(@word)
    end
    
end