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

end