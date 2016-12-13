require './lib/node'

class CompleteMe
  
  attr_reader :head

  def initialize
    @head = Node.new
  end

  def insert(word)
    @head.insert(word.downcase)
  end

  def count
    @head.get_list_of_words.length
  end

  def suggest(suggestion)
    search_node = @head.get_search_node(suggestion)
    words = search_node.get_list_of_words(suggestion)
    words
  end

  def populate(dictionary)
    words = dictionary.split("\n").sort
    words.each do |word|
      insert(word)
    end
  end

  # def select(suggestion, weighted_word)
  # end

  # def delete(existing_word)
  # end

end