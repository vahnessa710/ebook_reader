class VocabulariesController < ApplicationController

    # def index
    #     @response = WebsterApi.get_word(@word)
    #     @word = "computer"
    #     @definition = WebsterApi.get_definition(@word)
    # end

    def index
  @vocabularies = current_user.vocabularies.order(created_at: :asc)
end

    def show
         @word = Word.find(params[:id])
    end

     def search_form
    # just renders the search form
    end

    def search
       word = params[:keywords]

    if word.present?
      redirect_to vocabulary_path(word)  # goes to show with the word param
    else
      flash[:alert] = "Please enter a word to search."
      redirect_to search_form_vocabularies_path
    end

    end

     def show
    @word = params[:word]
    @definitions = []

    response = Dictionaryapi.get_words(@word)  # You should have a class to wrap your API logic

    if response.success?
      data = response.parsed_response

      entries = data.select { |entry| entry.is_a?(Hash) && entry['meanings']&.any? }

      if entries.any?
        # Extract all definitions from the first matching entry
        @definitions = entries.flat_map do |entry|
          entry['meanings'].flat_map { |meaning| meaning['definitions'].map { |d| d['definition'] } }
        end
      else
        flash[:alert] = "No definitions found for '#{@word}'."
        redirect_to search_form_vocabularies_path and return
      end
    else
      flash[:alert] = "Failed to fetch definition for '#{@word}'."
      redirect_to search_form_vocabularies_path and return
    end
  end



    def create
  @vocabulary = current_user.vocabularies.new(
    word: params[:word].strip.downcase,
    definition: params[:definition].strip
  )

  if @vocabulary.save
    flash[:notice] = "Saved '#{@vocabulary.word}' to your vocabulary list."
    redirect_to vocabulary_path(@vocabulary.word)
  else
    flash[:alert] = "Failed to save the word: " + @vocabulary.errors.full_messages.to_sentence
    redirect_to vocabulary_path(params[:word])
  end
end

    private

    def Vocabulary_params
        params.require(:Vocabulary).permit(:Vocabulary, :meaning)
    end
    
end