require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'

class CompleteMeTest < Minitest::Test

  def test_file_setup_correctly
    assert true
  end
  def test_complete_me_exists
    trie = CompleteMe.new

    assert trie
  end

  def test_head_exists
    trie = CompleteMe.new

    assert trie.head
  end

  def test_insert_single_letter
    trie = CompleteMe.new
    trie.insert("a")

    assert_equal ["a"], trie.head.links.keys
    assert_equal 1,     trie.head.links["a"].depth
  end

  def test_insert_short_word
    trie = CompleteMe.new
    trie.insert("bat")

    assert_equal ["b"], trie.head.links.keys
    assert_equal 1,     trie.head.links["b"].depth
    assert_equal false, trie.head.links["b"].end_of_word
    assert_equal false, trie.head.links["b"].links["a"].end_of_word
    assert_equal true,  trie.head.links["b"].links["a"].links["t"].end_of_word
  end

  def test_insert_short_words_overlap
    trie = CompleteMe.new
    trie.insert("bat")
    trie.insert("bar")
    trie.insert("bats")

    assert_equal ["b"], trie.head.links.keys
    assert_equal 1,     trie.head.links["b"].depth
    assert_equal false, trie.head.links["b"].end_of_word
    assert_equal false, trie.head.links["b"].links["a"].end_of_word
    assert_equal true,  trie.head.links["b"].links["a"].links["r"].end_of_word
    assert_equal true,  trie.head.links["b"].links["a"].links["t"].end_of_word
    assert_equal true,  trie.head.links["b"].links["a"].links["t"].links["s"].end_of_word
  end

  def test_suggest_three_words
    trie = CompleteMe.new
    trie.insert("bat")
    trie.insert("bar")
    trie.insert("bats")

    list_of_words = trie.suggest("ba").sort

    assert_equal ["bar","bat","bats"], list_of_words
  end

  def test_populate_three_words
    trie = CompleteMe.new

    trie.populate("pizza\ndog\ncat")

    assert_equal 3, trie.count
  end

  def test_populate_entire_dictionary
    trie = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")

    trie.populate(dictionary)

    assert_equal 234371, trie.count
  end

  def test_select_once
    trie = CompleteMe.new
    trie.insert("bat")
    trie.insert("bar")
    trie.insert("bare")

    trie.select("ba","bat")

    equals_hash = {"ba"=>1}
    assert_equal equals_hash, trie.head.links["b"].links["a"].links["t"].weights
  end

  def test_select_twice
    trie = CompleteMe.new
    trie.insert("bat")
    trie.insert("bar")
    trie.insert("bare")

    trie.select("ba","bat")
    trie.select("ba","bat")

    equals_hash = {"ba"=>2}
    assert_equal equals_hash, trie.head.links["b"].links["a"].links["t"].weights
  end

  def test_parse_out_weights_all_equal
    trie = CompleteMe.new
    words = { "bat" => {},
              "bar" => {},
              "bats" => {},
            }

    weighted_list = trie.parse_out_weights(words,"ba")

    assert_equal ["bar","bat","bats"], weighted_list
  end

  def test_parse_out_weights_all_different
    trie = CompleteMe.new
    words = { "bat" => {"ba" => 1},
              "bar" => {"ba" => 2},
              "bats" => {"ba" => 3},
            }

    weighted_list = trie.parse_out_weights(words,"ba")

    assert_equal ["bats","bar","bat"], weighted_list
  end

  def test_parse_out_weights_two_equal
    trie = CompleteMe.new
    words = { "bat" => {},
              "bar" => {"ba" => 1},
              "bats" => {"ba" => 1},
            }

    weighted_list = trie.parse_out_weights(words,"ba")

    assert_equal ["bar","bats","bat"], weighted_list
  end

  def test_populate_addresses
    trie = CompleteMe.new
    addresses = ["3690 N Monaco Street Pkwy", "3612 N Monaco Street Pkwy", "3265 N Krameria St", "6123 E Martin Luther King Blvd", "6101 E Martin Luther King Blvd", "3205 N Locust St", "6315 E Martin Luther King Blvd", "4595 N Quebec St", "3888 N Forest St"].join("\n")

    trie.populate(addresses)

    assert_equal ["3","4","6"], trie.head.links.keys
    assert_equal ["2","6","8"], trie.head.links["3"].links.keys
  end
  def test_populate_addresses
    trie = CompleteMe.new
    addresses = ["3690 N Monaco Street Pkwy", "3612 N Monaco Street Pkwy", "3265 N Krameria St", "6123 E Martin Luther King Blvd", "6101 E Martin Luther King Blvd", "3205 N Locust St", "6315 E Martin Luther King Blvd", "4595 N Quebec St", "3888 N Forest St"].join("\n")
    trie.populate(addresses)

    address = trie.suggest("3690")

    assert_equal "3690 N Monaco Street Pkwy", address
  end

end # class end




