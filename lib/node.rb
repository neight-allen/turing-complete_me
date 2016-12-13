class Node

  attr_reader :links,
              :end_of_word,
              :depth

  def initialize(depth=0)
    @links        = {}
    @end_of_word  = false
    @depth        = depth
  end

  def insert(word)

    letter = word[@depth]

    if letter.nil? #if we'ver reached the end of the word, end recursion
      @end_of_word = true
    else # otherwise
      if @links[letter].nil? # add a link to a new node for letter if one doesn't exist
        @links[letter] = Node.new(@depth+1)
      end
      # keep traveling/creating branch until we've finished the word
      child_node = @links[letter]
      child_node.insert(word)
    end
  end

  def get_search_node(suggestion)

    letter = suggestion[@depth]

    if letter.nil? #if we've reached the end of the word
      return self
    elsif @links[letter].nil? #if there is no link in the node's has for letter
      return nil
    else # otherwise, continue searching down the node branch
      child_node = @links[letter]
      child_node.get_search_node(suggestion)
    end

  end

  def get_list_of_words(suggestion="", list_of_words=[])
    # if this node is marked as the end of a word, add suggestion to list_of_words
    if @end_of_word
      list_of_words.push(suggestion)
    end
    # enumerate through the list of children
    @links.each do | letter, child_node |
      # for each child, run this method recursively
      list_of_words = child_node.get_list_of_words(suggestion + letter, list_of_words)
    end
    return list_of_words
  end

  def count(counter=0)



  end





end #class end