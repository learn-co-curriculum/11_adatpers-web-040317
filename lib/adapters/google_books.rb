class GoogleBooks
  attr_reader :query

  BASE_URL = 'https://www.googleapis.com/books/v1'

  DEFAULT_QUERIES = ["ruby programming", 'George Orwell', 'Elmore Leonard', 'Chuck Palahniuk', 'Steven Millhauser']

  def self.set_default_items
    DEFAULT_QUERIES.each do |query|
      self.new(query: query).create_books_and_authors
    end
  end

  def initialize(query:)
    @query = query
  end

  def response_data
    response = RestClient.get("#{BASE_URL}/volumes?q=#{query}")
    JSON.parse(response)
  end

  def books
    response_data['items']
  end

  def create_books_and_authors
    books.each do |book_info|
      create_book_and_author(book_info)
    end
  end

  private

  def create_book_and_author(book_info)
    book = Book.find_or_initialize_by(title:  book_info['volumeInfo']['title'])
    if book_info['volumeInfo']['authors'].present?
      author = Author.find_or_create_by(name: book_info['volumeInfo']['authors'].first )
      book.author = author
    end
    book.save
  end

end
