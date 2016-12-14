class Node

  attr_reader :links,
              :end_of_word,
              :depth,
              :weights

  def initialize(depth=0)
    @links        = {}
    @end_of_word  = false
    @depth        = depth
    @weights      = {}
  end

  def insert(word)
    letter = word[@depth]
    if letter.nil?
      @end_of_word = true
    else
      if @links[letter].nil?
        @links[letter] = Node.new(@depth+1)
      end
      child_node = @links[letter]
      child_node.insert(word)
    end
  end

  def get_node(suggestion)
    letter = suggestion[@depth]
    if letter.nil?
      return self
    elsif @links[letter].nil?
      return nil
    else
      child_node = @links[letter]
      child_node.get_node(suggestion)
    end
  end

  def get_list_of_words(suggestion="", list_of_words={})
    if @end_of_word
      list_of_words[suggestion] = self.weights
    end
    @links.each do | letter, child_node |
      list_of_words = child_node.get_list_of_words(suggestion + letter, list_of_words)
    end
    return list_of_words
  end

  def add_weight(suggestion)
    if @weights[suggestion].nil?
      @weights[suggestion] = 1
    else
      @weights[suggestion] += 1
    end
  end

end