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
    words = get_weight_for_each_word(words, suggestion)
    words = group_words_by_weight(words)
    words = get_list_of_words_by_weight(words)
    words = get_sorted_list(words)
    return words
  end

  private

  def disconnect_nodes(word)
    parent_node, node = @head.get_parent_and_child(word)
    if node.links.empty?
      parent_node.remove_link(word[-1])
      if parent_node.end_of_word == false
        disconnect_nodes(word[0..-2])
      end
    end
  end

  def get_weight_for_each_word(words, suggestion)
    words.each do | key, value|
      words[key] = value[suggestion].to_i
    end
    return words
  end

  def group_words_by_weight(words)
    words = words.group_by do | key, value |
      value
    end
    return words
  end

  def get_list_of_words_by_weight(words)
    words.each do | key, value |
      words_array = value.flatten
      words_array = words_array.find_all { | e | e.class == String }
      words[key] = words_array.sort!
    end
    return words
  end

  def get_sorted_list(words)
    final_list = []
    words.keys.sort.reverse.each do |key|
      final_list.concat(words[key])
    end
    return final_list
  end

end

