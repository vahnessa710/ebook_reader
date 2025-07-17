<<<<<<< HEAD
class VocabulariesController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      @vocabularies = current_user.vocabularies.order(created_at: :asc)
    end

    def search_form;  end

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
      @word = params[:id].strip.downcase
      @definitions = []
      response = Dictionaryapi.get_words(@word)
      if response.success?
        data = response.parsed_response
        entries = data.select { |entry| entry.is_a?(Hash) && entry['meanings']&.any? }
        if entries.any?
          @definitions = entries.flat_map do |entry|
          entry['meanings'].flat_map { |meaning| meaning['definitions'].map { |d| d['definition'] } }
        end
        # Save to vocabulary list automatically if not already saved
      unless current_user.vocabularies.exists?(word: @word)
        current_user.vocabularies.create(
        word: @word,
        definition: @definitions.first # or join multiple definitions if you prefer
        )
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

    def destroy
      @vocabulary = Vocabulary.find(params[:id])
      @vocabulary.destroy
      redirect_to vocabularies_path, notice: "Word was successfully deleted."
    end

    private

    def Vocabulary_params
        params.require(:Vocabulary).permit(:Vocabulary, :meaning)
    end

    def record_not_found
      redirect_to  vocabularies_path, alert: "That record doesn't exist!"
    end

    
=======
class VocabulariesController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      @vocabularies = current_user.vocabularies.order(created_at: :desc)
    end

    def search_form;  end

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
      @word = params[:id].strip.downcase
      @definitions = []
      response = Dictionaryapi.get_words(@word)
      if response.success?
        data = response.parsed_response
        entries = data.select { |entry| entry.is_a?(Hash) && entry['meanings']&.any? }
        if entries.any?
          @definitions = entries.flat_map do |entry|
          entry['meanings'].flat_map { |meaning| meaning['definitions'].map { |d| d['definition'] } }
        end
        # Save to vocabulary list automatically if not already saved
      unless current_user.vocabularies.exists?(word: @word)
        current_user.vocabularies.create(
        word: @word,
        definition: @definitions.first # or join multiple definitions if you prefer
        )
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

    def destroy
      @vocabulary = Vocabulary.find(params[:id])
      @vocabulary.destroy
      redirect_to vocabularies_path, notice: "Word was successfully deleted."
    end

    private

    def vocabulary_params
        params.require(:Vocabulary).permit(:Vocabulary, :meaning)
    end

    def record_not_found
      redirect_to vocabularies_path, alert: "That record doesn't exist!"
    end

    
>>>>>>> origin/book_branch_2
end