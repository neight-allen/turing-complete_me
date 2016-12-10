require './lib/node'

class CompleteMe
  
  attr_reader :head

  def initialize
    @head = Node.new
  end

  def insert(word)
    @head.insert(word)
  end

  def count
    # output = number_of_words_in_tree
  end

  def suggest(suggestion)
    # output = array_of_words
  end

  def populate(dictionary)
    # output = none
  end

  # def select(suggestion, weighted_word)
  # end

  # def delete(existing_word)
  # end

end