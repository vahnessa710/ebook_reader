class WebsterApi
  include HTTParty
  base_uri "https://www.dictionaryapi.com/api/v3/references/collegiate/json"

  def self.get_word(word)
    response = get("/#{word}", query: { key: ENV["dictionary_key"] })
    if response.success?
        response.parsed_response
    else
        { error: "Unable to fetch definition." }
    end
  end

  def self.get_definition(word)
    word_data = self.get_word(word)

    # Check if the response is a valid array of word entries
    if word_data
      definition = word_data.first["shortdef"].join("; ")
      return definition if definition
    end

    "Definition not available"
  end

end
