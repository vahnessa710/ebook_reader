class GutendexApi
  include HTTParty
  base_uri 'https://gutendex.com/books'

  def self.search_books(query = {})
    get('/', query: query)
  end

  def self.get_book(id)
    get("/#{id}")
  end

  def self.get_book_content(book_id)
    book_data = get_book(book_id) # fetch metadata

    if book_data.success?
      formats = book_data['formats']
      text_url = formats['text/plain; charset=us-ascii'] || formats['text/plain']
      text_url ||= formats['text/html']

      if text_url
        response = HTTParty.get(text_url)
        return response.body if response.success?
      end
    end
    "Content not available."
  end

end
