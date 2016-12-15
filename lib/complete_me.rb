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
    search_node = @head.get_node(suggestion)
    words = search_node.get_list_of_words(suggestion)
    weighted_list = parse_out_weights(words, suggestion)
    return weighted_list
  end

  def populate(dictionary)
    words = dictionary.split("\n").sort
    words.each do |word|
      insert(word)
    end
  end

  def select(suggestion, weighted_word)
    node = @head.get_node(weighted_word)
    node.add_weight(suggestion)
  end

  def delete(existing_word)
    node = @head.get_node(existing_word)
    node.remove_word
    disconnect_nodes(existing_word)
  end

  def parse_out_weights(words, suggestion)
    weighted_word_list = {}
    words.each do |word, weights|
      if weights[suggestion].nil?
        new_weight = 0
      else
        new_weight = weights[suggestion]
      end
      if weighted_word_list[new_weight].nil?
        weighted_word_list[new_weight] = [word]
      else
        weighted_word_list[new_weight].push(word)
      end
    end
    final_list = []
    weighted_word_list.keys.sort.reverse.each do |num|
      final_list.concat(weighted_word_list[num].sort)
    end
    return final_list
  end

  def disconnect_nodes(word)
    parent_node, node = @head.get_parent_and_child(word)
    if node.links.empty?
      parent_node.remove_link(word[-1])
      if parent_node.end_of_word == false
        disconnect_nodes(word[0..-2])
      end
    end
  end

end

