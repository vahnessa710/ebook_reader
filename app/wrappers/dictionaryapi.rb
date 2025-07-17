<<<<<<< HEAD
require 'net/http'
require 'json'
require 'uri'
require 'httparty'

class Dictionaryapi
  include HTTParty
  base_uri 'https://api.dictionaryapi.dev/api/v2/entries/en'

  def self.get_words(word)
    get("/#{word}")
  end
=======
require 'net/http'
require 'json'
require 'uri'
require 'httparty'

class Dictionaryapi
  include HTTParty
  base_uri 'https://api.dictionaryapi.dev/api/v2/entries/en'

  def self.get_words(word)
    get("/#{word}")
  end
>>>>>>> origin/book_branch_2
end